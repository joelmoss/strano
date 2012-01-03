class Github

  class InvalidAccessToken < StandardError; end
  
    
  def initialize(access_token = nil)
    @access_token = access_token || self.class.strano_user_token
    raise InvalidAccessToken, 'A valid Github access token is required.' if @access_token.nil?
  end
  
  def user
    Github::User.new @access_token
  end
  
  def key
    Github::Key.new @access_token
  end
  
  def orgs
    Github::Orgs.new @access_token
  end
  
  def repos
    Github::Repos.new @access_token
  end
  
  # Gets a Github repo based on the given user name and repo name.
  # 
  # user_name - The Github username as a String.
  # repo_name - The Github repo name as a String.
  # 
  # Returns a Github::Repo object.
  def repo(user_name, repo_name)
    Github::Repo.new @access_token, user_name, repo_name
  end

  def self.strano_user_token
    strano_store[:strano_user_token]
  end

  def self.strano_user_token=(value)
    strano_store[:strano_user_token] = value
  end
  
  # Thread-safe hash to hold the current user for when a model doesn't have
  # a user association or does not know the user's access token.
  def self.strano_store
    Thread.current[:strano] ||= {}
  end

end