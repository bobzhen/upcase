require "rails_helper"

describe GithubFulfillment do
  describe "#fulfill" do
    it "adds GitHub user to the github team" do
      repository = build_stubbed(:repository)
      user = build_stubbed(:user, github_username: "github_username")
      allow(GithubFulfillmentJob).to receive(:enqueue)

      GithubFulfillment.new(repository, user).fulfill

      expect(GithubFulfillmentJob).to have_received(:enqueue).
        with(repository.id, user.id)
    end

    it "doesn't fulfill using GitHub with a blank GitHub team" do
      repository = build_stubbed(:show, github_team: nil)
      user = build_stubbed(:user, github_username: "github_username")
      allow(GithubFulfillmentJob).to receive(:enqueue)

      GithubFulfillment.new(repository, user).fulfill

      expect(GithubFulfillmentJob).not_to have_received(:enqueue)
    end
  end

  describe "#remove" do
    it "removes user from github team" do
      allow(GithubRemovalJob).to receive(:enqueue)
      repository = build_stubbed(:repository)
      user = build_stubbed(:user, github_username: "test")

      GithubFulfillment.new(repository, user).remove

      expect(GithubRemovalJob).to have_received(:enqueue).
        with(repository.github_team, "test")
    end

    it "doesn't remove using GitHub with a blank GitHub team" do
      allow(GithubRemovalJob).to receive(:enqueue)
      repository = build(:show, github_team: nil)
      user = create(:user, github_username: "test")

      GithubFulfillment.new(repository, user).remove

      expect(GithubRemovalJob).not_to have_received(:enqueue)
    end
  end
end
