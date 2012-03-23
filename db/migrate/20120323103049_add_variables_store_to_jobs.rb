class AddVariablesStoreToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :variables, :text
  end
end
