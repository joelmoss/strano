class RenameGithubDataToData < ActiveRecord::Migration
  def change
    rename_column :projects, :github_data, :data
  end
end
