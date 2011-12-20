class AddCompletedAtToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :completed_at, :datetime
  end
end