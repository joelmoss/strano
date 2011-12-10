class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, :github_access_token
      t.text :github_data
      t.boolean :ssh_key_uploaded_to_github, :default => false

      t.timestamps
    end
    add_index :users, :email, :unique => true
  end
end
