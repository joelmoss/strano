Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, Strano.github_key, Strano.github_secret, :scope => "user,repo"
end