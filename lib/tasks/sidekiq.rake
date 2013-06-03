namespace :sidekiq do
  desc "Strano | Stop sidekiq"
  task :stop do
    system "bundle exec sidekiqctl stop #{pidfile}"
  end

  desc "Strano | Start sidekiq"
  task :start do
    system "nohup bundle exec sidekiq -q runner,common,default -e #{Rails.env} -P #{pidfile} >> #{Rails.root.join("log", "sidekiq.log")} 2>&1 &"
  end

  def pidfile
    Rails.root.join("tmp", "pids", "sidekiq.pid")
  end
end
