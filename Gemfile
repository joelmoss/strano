source 'http://rubygems.org'

gem 'rails', '3.1.3'
gem 'mysql2'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.1.5'
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'twitter-bootstrap-rails'
gem 'devise'
gem 'omniauth-github'
gem 'github_api', :git => "https://github.com/joelmoss/github.git"
gem 'capistrano'
gem 'grit'
gem 'girl_friday'
gem 'dotiw'
gem 'inherited_resources'
gem 'simple_form', :git => 'https://github.com/plataformatec/simple_form.git'

group :development, :test do
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'guard-pow'
  gem 'rb-fsevent'
  gem 'growl'
  
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem "database_cleaner"
  gem 'marked'
  gem 'ffaker'
  gem 'vcr'
end  
  
group :test do
  gem 'sqlite3'
  gem 'webmock'
  gem "fakefs", :require => "fakefs/safe"
end