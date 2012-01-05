class AddPullStatusToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :pull_in_progress, :boolean, :default => 0
    add_column :projects, :pulled_at, :datetime
  end
end