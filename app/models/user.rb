class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :remember_me
  
  serialize :github_data
  
  delegate :login, :avatar_url, :html_url, :to => :github_data
  
  
  def to_s
    login
  end
  
  def github_data
    @github_data ||= Hashie::Mash.new(read_attribute(:github_data))
  end
  
end
