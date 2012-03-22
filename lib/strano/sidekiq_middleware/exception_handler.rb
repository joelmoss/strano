module Strano
  module SidekiqMiddleware
    class ExceptionHandler
      include Sidekiq::Util

      def call(*args)
        yield
      rescue => ex
        if args[1]['class'] == 'Job::CapExecute' && job = Job.find(args[1]['args'].first)
          results = (job.results || '') + "#{CGI::escapeHTML(ex.message)}\n" + ex.backtrace.join("\n")
          job.update_attributes :results => results,
                                :completed_at => Time.now,
                                :success => false
        else
          raise
        end
      end

    end
  end
end