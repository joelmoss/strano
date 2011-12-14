class AddGithubDataToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :github_data, :text
  end
end