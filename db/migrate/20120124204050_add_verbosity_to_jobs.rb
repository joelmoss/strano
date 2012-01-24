class AddVerbosityToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :verbosity, :string, :default => 'v'
  end
end