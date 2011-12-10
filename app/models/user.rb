class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable
  
  cattr_accessor :disable_ssh_github_upload

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :github_data, :github_access_token
  
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
  # Returns a Hashie::Mash object.
  def github_data
    @github_data ||= Hashie::Mash.new(read_attribute(:github_data))
  end
  
  # Returns an authenticated instance of Github::Users.
  def github
    @github ||= begin
      Github::Users.new(:oauth_token => github_access_token) if github_access_token.present?
    end
  end
  
  # Is this user authorized for full Github API access using an OAuth access
  # token?
  # 
  # Returns a Boolean.
  def authorized_for_github?
    !github.nil?
  end

  
  private
  
    # Upload SSH key to github, but not if disable_ssh_github_upload is true.
    # User must also be authorized for Github API access.
    def upload_ssh_key_to_github
      if !self.class.disable_ssh_github_upload && authorized_for_github?
        github.create_key(:title => "Strano", :key => ENV['STRANO_PUBLIC_SSH_KEY'])
        self.toggle! :ssh_key_uploaded_to_github
      end
    rescue Github::Error => e
      # do nothing
    end
  
end
