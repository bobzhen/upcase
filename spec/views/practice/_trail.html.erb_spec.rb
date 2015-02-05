require "rails_helper"

describe "practice/_trail.html" do
  context "with a just_finished trail" do
    it "renders as just_finished" do
      trail = stub_trail(just_finished: true)

      render_trail trail

      expect(rendered).to have_content(trail.name)
      expect(rendered).to have_just_finished(trail)
    end
  end

  context "with an injust_finished trail" do
    it "renders as injust_finished" do
      trail = stub_trail(just_finished: false)

      render_trail trail

      expect(rendered).to have_content(trail.name)
      expect(rendered).not_to have_just_finished(trail)
    end
  end

  context "with an unstarted trail" do
    it "renders as unstarted" do
      trail = stub_trail(just_finished: false, unstarted: true)

      render_trail trail

      expect(rendered).to have_selector(".unstarted")
      expect(rendered).to have_content(trail.name)
      expect(rendered).not_to have_just_finished(trail)
    end
  end

  def stub_trail(just_finished:, unstarted: false)
    topic = build_stubbed(:topic, slug: "clean+code")
    build_stubbed(:trail, topic: topic).tap do |trail|
      allow(trail).to receive(:unstarted?).and_return(unstarted)
      allow(trail).to receive(:just_finished?).and_return(just_finished)
    end
  end

  def render_trail(trail)
    view_stubs(:current_user).and_return(build_stubbed(:user))
    render "practice/trail", trail: trail
  end

  def have_just_finished(trail)
    have_content(trail.complete_text)
  end
end
