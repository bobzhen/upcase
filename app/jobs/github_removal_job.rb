class GithubRemovalJob < ActiveJob::Base
  include ErrorReporting

  def perform(repository, username)
    begin
      github_client.remove_collaborator(repository, username)
    rescue Octokit::NotFound, Net::HTTPBadResponse => e
      Honeybadger.notify(e)
    end
  end

  private

  def github_client
    Octokit::Client.new(login: GITHUB_USER, password: GITHUB_PASSWORD)
  end
end
