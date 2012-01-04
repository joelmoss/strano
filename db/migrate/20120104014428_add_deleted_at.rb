class AddDeletedAt < ActiveRecord::Migration
  def change
    add_column :jobs, :deleted_at, :datetime
    add_column :projects, :deleted_at, :datetime
    add_column :users, :deleted_at, :datetime
  end
end