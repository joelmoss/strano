source 'http://rubygems.org'

gem 'rails', '~> 3.2'
gem 'mysql2'
gem 'sqlite3'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'twitter-bootstrap-rails'
gem 'resque'
gem 'omniauth-github'
gem 'yajl-ruby'
gem 'faraday'
gem 'faraday-stack'
gem 'faraday_middleware'
gem 'capistrano', '~> 2.10.0.pre'
gem 'capistrano_colors'
gem 'grit'
gem 'dotiw'
gem 'inherited_resources'
gem 'kaminari'
gem 'permanent_records'
gem 'simple_form', :git => 'https://github.com/plataformatec/simple_form.git'
gem 'open4'
gem 'ansible'

gem 'whenever', :require => nil
gem 'airbrake', :require => nil

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
  gem 'vcr', '~> 2.0.0.rc'
end

group :test do
  gem 'webmock'
  gem 'resque_spec'
  gem "fakefs", :require => "fakefs/safe"
end