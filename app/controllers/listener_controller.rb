class ListenerController < ApplicationController
  before_filter :validate_signature

  def github
    if params[:ref] == 'refs/heads/master'
      repo_name = params[:repository][:name]
      owner_name = params[:repository][:owner][:name]
      project_url = "git@github.com:#{owner_name}/#{repo_name}.git"
      if project = Project.find_by_url(project_url)
        project.jobs.create({:task => 'deploy', :branch => 'master'})
      end
    end
    head :no_content
  end

  private

  def validate_signature
    if signature = request.headers['HTTP_X_HUB_SIGNATURE']
      digest = OpenSSL::Digest::Digest.new("sha1")
      signature = signature.split("=").last

      sig = OpenSSL::HMAC.hexdigest(
        digest,
        Strano.github_hook_secret,
        request.body.read
      )

      return true if signature == OpenSSL::HMAC.hexdigest(
        digest,
        Strano.github_hook_secret,
        request.body.read
      )
    end

    head :unauthorized
  end
end
