module Strano
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring a
    # {Strano::API.
    VALID_OPTIONS_KEYS = [
      :public_ssh_key,
      :clone_path,
      :github_key,
      :github_secret,
      :github_hook_secret,
      :base_url,
      :allow_organizations,
      :allow_users].freeze

    # The public SSH key that Strano will add to each users Github account
    # so that Strano can clone github repos locally.
    DEFAULT_PUBLIC_SSH_KEY = nil

    # The file path to where local repos will be cloned to.
    DEFAULT_CLONE_PATH = Rails.root.join("vendor/repos")

    # The application key of the Strano application in Github. See
    # https://github.com/account/applications
    DEFAULT_GITHUB_KEY = nil
    
    # The application secret of the Strano application in Github. See
    # https://github.com/account/applications
    DEFAULT_GITHUB_SECRET = nil
    
    # Secret used to sign hook requests from GitHub.
    DEFAULT_GITHUB_HOOK_SECRET = 'topsecret'

    # The application URL with a trailing slash, required for github hooks.
    DEFAULT_BASE_URL = nil

    # Allow project creation from repos for Github organization accounts.
    # Default value is true, which allows any and all organizations. Set to
    # false to disallow creating projects from organizations completely.
    # Pass an array of Github organization usernames to restrict which
    # projects Strano can create new projects for.
    DEFAULT_ALLOW_ORGANIZATIONS = true
    
    # Allow project creation from repos for Github user accounts. Default
    # value is true, which allows any and all users. Set to false to disallow
    # creating projects from users completely. Pass an array of Github
    # usernames to restrict which projects Strano can create new projects for.
    DEFAULT_ALLOW_USERS = true

    attr_accessor *VALID_OPTIONS_KEYS


    # Public: When this module is extended, set all configuration options to
    # their default values.
    def self.extended(base)
      base.reset
    end

    def allow_users
      if @allow_users.is_a?(String) || @allow_users.is_a?(Symbol)
        [@allow_users.to_s]
      else
        @allow_users.is_a?(Array) ? @allow_users.map(&:to_s) : @allow_users
      end
    end

    # Returns a Boolean true if we are allowed to create projects from Github
    # user repos.
    def allow_users?
      allow_users.is_a?(Array) ? !allow_users.empty? : allow_users
    end
    
    # Returns a Boolean true if the given username is allowed to create projects
    # from their own Github repos.
    def allow_users_include?(username)
      allow_users.is_a?(Array) ? allow_users.include?(username) : allow_users?
    end
    
    def allow_organizations
      if @allow_organizations.is_a?(String) || @allow_organizations.is_a?(Symbol)
        [@allow_organizations.to_s]
      else
        @allow_organizations.is_a?(Array) ? @allow_organizations.map(&:to_s) : @allow_organizations
      end
    end
    
    # Returns a Boolean true if we are allowed to create projects from Github
    # organization repos.
    def allow_organizations?
      allow_organizations.is_a?(Array) ? !allow_organizations.empty? : allow_organizations
    end
    
    # Returns a Boolean true if the given organization is allowed to create
    # projects from their own Github repos.
    def allow_organizations_include?(org)
      allow_organizations.is_a?(Array) ? allow_organizations.include?(org) : allow_organizations?
    end

    # Public: Convenience method to allow configuration options to be set in a
    # block.
    # 
    # Examples
    # 
    #   Strano.configure do |config|
    #     config.consumer_key = 'anotherkey'
    #   end
    def configure
      yield self
    end

    # Public: Create a hash of options and their values.
    # 
    # Returns the Hash of options.
    def options
      options = {}
      VALID_OPTIONS_KEYS.each { |k| options[k] = send(k) }
      options
    end

    # Public: Reset all configuration options to defaults.
    # 
    # Returns self.
    def reset
      self.public_ssh_key       = DEFAULT_PUBLIC_SSH_KEY
      self.clone_path           = DEFAULT_CLONE_PATH
      self.github_key           = DEFAULT_GITHUB_KEY
      self.github_secret        = DEFAULT_GITHUB_SECRET
      self.github_hook_secret   = DEFAULT_GITHUB_HOOK_SECRET
      self.base_url             = DEFAULT_BASE_URL
      self.allow_organizations  = DEFAULT_ALLOW_ORGANIZATIONS
      self.allow_users          = DEFAULT_ALLOW_USERS
      self
    end
  end
end
