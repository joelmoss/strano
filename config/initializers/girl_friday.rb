# class MyErrorHandler
#   def handle(ex)
#     mark ex.message
#   end
# end
# 
# REPO_CLONE_QUEUE = GirlFriday::WorkQueue.new(:repo_clone, :error_handler => MyErrorHandler) do |msg|
#   Strano::Repo.clone(msg)
# end
# 
# REPO_REMOVE_QUEUE = GirlFriday::WorkQueue.new(:repo_remove, :error_handler => MyErrorHandler) do |msg|
#   Strano::Repo.remove(msg)
# end
# 
# CAP_EXECUTE_QUEUE = GirlFriday::WorkQueue.new(:cap_execute, :error_handler => Job::ErrorHandler) do |msg|
#   Job.find(msg[:job_id]).run_task
# end