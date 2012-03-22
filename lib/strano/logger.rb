# a logger for Capistrano::Configuration that logs to the database
module Strano
  class Logger < Capistrano::Logger
    attr_accessor :job

    def initialize(job)
      raise ArgumentError, 'task is already completed and thus can not be logged to' if job.complete?
      @job, @level = job, 0
    end

    def log(level, message, line_prefix=nil)
      if level <= self.level
        indent = "%*s" % [MAX_LEVEL, "*" * (MAX_LEVEL - level)]
        (message.respond_to?(:lines) ? message.lines : message).each do |line|
          if line_prefix
            write_msg "#{indent} [#{line_prefix}] #{line.strip}\n"
          else
            write_msg "#{indent} #{line.strip}\n"
          end
        end
      end
    end

    def close
      # not needed here
    end

    # actual writing of a msg to the DB
    def write_msg(msg)
      job.update_attribute :results, (job.results || '') + msg unless msg.blank?
    end

  end
end