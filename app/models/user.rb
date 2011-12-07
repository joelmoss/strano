class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email
  
  # The github data will be serialzed as a Hash.
  serialize :github_data
  
  # Delegate github attributes to #github_data.
  delegate :login, :avatar_url, :html_url, :to => :github_data
  
  # After creation, upload the Strano SSH public key to the user's Github account,
  # so we can clone private repos.
  after_create :upload_ssh_key
  
  
  def to_s
    login
  end
  
  # Convert the github data into a Hashie::Mash object, so that delegation works.
  # 
  # Returns the #github_data as a Hashie::Mash object.
  def github_data
    @github_data ||= Hashie::Mash.new(read_attribute(:github_data))
  end
  
  # TODO: upload SSH key to github
  def upload_ssh_key
    
  end
  
end
