class AddClonedAtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :cloned_at, :datetime
  end
end