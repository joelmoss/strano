# Implementation of Capistrano::Configuration that uses a Strano::Logger as the
# logger in order to log to the DB.
module CapistranoMonkey
  class Configuration < Capistrano::Configuration

    # default callback to handle all output that
    # the other callbacks not explicitly handle.
    def self.default_io_proc
      Proc.new do |ch, stream, out|
        level = stream == :err ? :important : :info
        ch[:options][:logger].send(level, out, "#{stream} :: #{ch[:server]}")
      end
    end

  end
end