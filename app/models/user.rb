class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :remember_me
  
  serialize :github_data
  
  
  def to_s
    github_data[:login]
  end
end
