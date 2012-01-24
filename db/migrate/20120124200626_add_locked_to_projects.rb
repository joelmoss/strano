class AddLockedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :job_in_progress_id, :integer
  end
end