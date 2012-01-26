module Strano
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring a
    # {Strano::API.
    VALID_OPTIONS_KEYS = [
      :public_ssh_key,
      :clone_path,
      :github_key,
      :github_secret].freeze

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

    attr_accessor *VALID_OPTIONS_KEYS


    # Public: When this module is extended, set all configuration options to
    # their default values.
    def self.extended(base)
      base.reset
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
      self.public_ssh_key = DEFAULT_PUBLIC_SSH_KEY
      self.clone_path     = DEFAULT_CLONE_PATH
      self.github_key     = DEFAULT_GITHUB_KEY
      self.github_secret  = DEFAULT_GITHUB_SECRET
      self
    end
  end
end