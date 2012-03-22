Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Strano::SidekiqMiddleware::ExceptionHandler
  end
end