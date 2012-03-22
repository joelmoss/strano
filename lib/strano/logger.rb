# a logger for Capistrano::Configuration that logs to the database
require 'capistrano_colors/configuration'
require 'capistrano_colors/logger'

module Strano
  class Logger < Capistrano::Logger
    attr_accessor :job

    def initialize(job)
      raise ArgumentError, 'task is already completed and thus can not be logged to' if job.complete?
      @job, @level = job, 0
    end

    def close
      # not needed here
    end

    alias :device :job

  end
end