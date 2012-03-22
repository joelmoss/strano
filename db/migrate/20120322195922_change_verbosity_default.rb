class ChangeVerbosityDefault < ActiveRecord::Migration
  def change
    change_column :jobs, :verbosity, :string, :default => "vvv"
  end
end
