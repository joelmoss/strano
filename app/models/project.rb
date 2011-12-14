class Project < ActiveRecord::Base

  # The github data will be serialzed as a Hash.
  serialize :github_data

  belongs_to :user

  after_create :clone_repo
  before_save :update_github_data
  after_destroy :remove_repo
  
  delegate :user_name, :repo_name, :to => :repo


  def to_s
    "#{user_name}/#{repo_name}"
  end

  # Convert the github data into a Hashie::Mash object, so that delegation works.
  #
  # Returns a Hashie::Mash object.
  def github_data
    @github_data ||= Hashie::Mash.new(read_attribute(:github_data))
  end

  # Returns an authenticated instance of Github::Repos.
  def github
    @github ||= user.github.repos(:user => repo.user_name, :repo => repo.repo_name)
  end

  # Returns a Strano::Repo instance.
  def repo
    @repo ||= Strano::Repo.new(url)
  end


  private

    def clone_repo
      REPO_CLONE_QUEUE << url
    end

    def remove_repo
      REPO_REMOVE_QUEUE << url
    end

    def update_github_data
      self.github_data = github.get_repo
    end

end
