class MyErrorHandler
  def handle(ex)
    puts ex.message
  end
end

CLONE_QUEUE = GirlFriday::WorkQueue.new(:git_clone, :error_handler => MyErrorHandler) do |msg|
  Strano::Repo.clone(msg)
end