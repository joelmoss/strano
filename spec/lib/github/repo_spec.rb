require "spec_helper"

describe Github::Repo do

  let(:url) { 'git@github.com:yevgenko/strano.git' }
  let(:repo) { Strano::Repo.new(url) }
  let(:github) { Github.new('somerandomkey') }

  describe "#hook" do
    use_vcr_cassette :erb => true

    it { github.repo(repo.user_name, repo.repo_name).hook('http://example.com/listener', 'secret') }
  end

end
