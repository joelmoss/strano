class ChangeVariablesToBranch < ActiveRecord::Migration
  def change
    change_column :jobs, :variables, :string
    rename_column :jobs, :variables, :branch
  end
end
