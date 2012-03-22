module Strano
  module SidekiqMiddleware
    class ExceptionHandler
      include Sidekiq::Util

      def call(*args)
        yield
      rescue => ex
        logger.warn ex
        logger.warn args
        logger.warn ex.backtrace.join("\n")

        raise
      end

    end
  end
end