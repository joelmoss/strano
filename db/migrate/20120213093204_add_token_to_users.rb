class AddTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token, :string
    
    User.find_each do |u|
      u.update_attribute :token, SecureRandom.hex(32)
    end
  end
end