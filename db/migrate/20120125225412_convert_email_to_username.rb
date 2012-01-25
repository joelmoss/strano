class ConvertEmailToUsername < ActiveRecord::Migration
  def change
    rename_column :users, :email, :username
    remove_index :users, :email
    add_index :users, :username
    
    User.find_each do |u|
      u.update_attribute :username, u.login
    end
  end
end