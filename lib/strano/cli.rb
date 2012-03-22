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

    # override in order to use DB logger
    def instantiate_configuration(options={})
      config = CapistranoMonkey::Configuration.new(options)
      config.logger = logger
      config
    end

    # override in order to use DB logger
    def handle_error(error)
      case error
        when Net::SSH::AuthenticationFailed
          logger.important "authentication failed for `#{error.message}'"
        when Capistrano::Error
          logger.important error.message
      else
        # we did not expect this error, so log the trace
        logger.important error.message + "\n" + error.backtrace.join("\n")
      end
    end

  end
end