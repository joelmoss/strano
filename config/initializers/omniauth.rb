Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['STRANO_GITHUB_KEY'], ENV['STRANO_GITHUB_SECRET'], :scope => "user,repo"
end