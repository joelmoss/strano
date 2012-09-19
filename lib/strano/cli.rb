require 'capistrano/cli'
module Strano
  # Defines constants and methods related to configuration
  class CLI < Capistrano::CLI

    attr_accessor :logger


    def self.parse(logger, args)
      cli = new(args)
      cli.parse_options!

      @logger = logger
      @logger.level = Strano::Logger::TRACE

      cli.logger = logger
      cli
    end

    # Override in order to use DB logger
    def instantiate_configuration(options={})
      config = Capistrano::Configuration.new(options)
      config.logger = logger
      config
    end

    # Override in order to use DB logger
    def handle_error(error)
      if error.is_a?(Net::SSH::AuthenticationFailed)
        logger.important "authentication failed for `#{error.message}'"
      else
        logger.important CGI::escapeHTML(error.message)
        logger.trace error.backtrace.join("\n")
      end

      false
    end

  end
end
