class AddSuccessToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :success, :boolean, :default => true
  end
end