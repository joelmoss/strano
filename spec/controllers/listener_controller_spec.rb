require "spec_helper"

# helper method to simulate POST from GitHub
def post_github(request, sig=nil)
  # load webhook example from file
  payload = File.open(Rails.root.join('spec/fixtures/github/webhook.json'), 'r') { |f| f.read }

  # make valid signature if necessary
  unless sig
    digest = OpenSSL::Digest::Digest.new("sha1")
    sig = OpenSSL::HMAC.hexdigest(
      digest,
      Strano.github_hook_secret,
      payload
    )
    request.env['HTTP_X_HUB_SIGNATURE'] = "sha1=#{sig}"
  end

  request.env['HTTP_CONTENT_TYPE'] = 'application/json'
  request.env['RAW_POST_DATA'] = payload
  post :github, JSON.parse(payload)
end

describe ListenerController do
  describe "POST #github" do
    context "with a valid signature" do
      let(:url) { 'git@github.com:yevgenko/cap-foobar.git' }
      let(:jobs) { stub(:jobs, create: true) }
      let(:project) { Project.new }

      before(:each) do
        project.stub(:jobs).and_return(jobs)
        Project.stub(:find_by_url).and_return(project)
      end

      it "should respond with 'No Content'" do
        post_github(@request)
        should respond_with 204
      end

      it "finds the project" do
        Project.should_receive(:find_by_url).with(url)
        post_github(@request)
      end

      it "creates the job" do
        jobs.should_receive(:create)
        post_github(@request)
      end
    end

    context "with invalid signature" do
      it "should respond with 'Unauthorized'" do
        post_github(@request, 'invalid-signature')
        should respond_with 401
      end
    end
  end
end
