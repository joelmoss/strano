class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable
  
  cattr_accessor :disable_ssh_github_upload

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email
  
  # The github data will be serialzed as a Hash.
  serialize :github_data
  
  # Delegate github attributes to #github_data.
  delegate :login, :avatar_url, :html_url, :to => :github_data
  
  # After creation, upload the Strano SSH public key to the user's Github account,
  # so we can clone private repos.
  after_create :upload_ssh_key_to_github
  
  
  def to_s
    login
  end
  
  # Convert the github data into a Hashie::Mash object, so that delegation works.
  # 
  # Returns the #github_data as a Hashie::Mash object.
  def github_data
    @github_data ||= Hashie::Mash.new(read_attribute(:github_data))
  end
  
  # Returns an authenticated instance of Github::Users.
  def github
    @github ||= begin
      Github::Users.new(:oauth_token => github_access_token) if github_access_token.present?
    end
  end

  
  private
  
    # Upload SSH key to github, but not if disable_ssh_github_upload is true.
    def upload_ssh_key_to_github
      unless self.class.disable_ssh_github_upload
        github.create_key(:title => "Strano", :key => ENV['STRANO_PUBLIC_SSH_KEY'])
      end
    end
  
end
