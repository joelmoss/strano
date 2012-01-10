require 'capistrano/cli'

class Project < ActiveRecord::Base

  class CloneRepo
    @queue = :project
    
    def self.perform(project_id)
      project = Project.find(project_id)
      project.update_column :pull_in_progress, true
      
      Strano::Repo.clone project.url
      
      Project.update_all({:updated_at => Time.now,
                          :cloned_at => Time.now,
                          :pulled_at => Time.now,
                          :pull_in_progress => false},
                          :id => project_id)
    end
  end
  
  class PullRepo
    @queue = :project
    
    def self.perform(project_id)
      project = Project.find(project_id)
      project.update_column :pull_in_progress, true
      
      Strano::Repo.pull project.url
      
      Project.update_all({:updated_at => Time.now,
                          :pulled_at => Time.now,
                          :pull_in_progress => false},
                          :id => project_id)
    end
  end
  
  class RemoveRepo
    @queue = :project
    
    def self.perform(project_id)
      Strano::Repo.remove Project.unscoped.find(project_id).url
    end
  end


  # The github data will be serialzed as a Hash.
  serialize :github_data

  has_many :jobs, :dependent => :destroy

  validate :url, :presence => true, :uniqueness => { :case_sensitive => false }

  after_create :clone_repo
  before_save :update_github_data
  after_destroy :remove_repo

  # Lets do some delegation so that we can access some common methods directly.
  delegate :user_name, :repo_name, :cloned?, :capified?, :to => :repo
  delegate :html_url, :description, :organization, :to => :github_data
  
  default_scope where(:deleted_at => nil)


  def self.deleted
    self.unscoped.where 'deleted_at IS NOT NULL'
  end

  def to_s
    "#{user_name}/#{repo_name}"
  end

  # Is this project part of a Github organisation profile?
  #
  # Returns a Boolean true if it is part of an organisation.
  def organization?
    organization.present?
  end

  # Has this project completed cloning?
  #
  # Returns a Boolean true if it has been cloned.
  def cloned?
    !cloned_at.blank?
  end

  # Does the given user have access to this project's repository?
  #
  # user - The current_user User object.
  #
  # Returns a Boolean true if the user has access.
  def accessible_by?(user)
    !!github.to_hash
  rescue
    false
  end

  # Convert the github data into a Hashie::Mash object, so that delegation works.
  #
  # Returns a Hashie::Mash object.
  def github_data
    @github_data ||= Hashie::Mash.new(read_attribute(:github_data))
  end

  # Returns an un-authenticated instance of Github::Repos.
  def github
    @github ||= Github.new.repo(repo.user_name, repo.repo_name)
  end

  # Returns a Strano::Repo instance.
  def repo
    @repo ||= Strano::Repo.new(url)
  end

  # The public task list for this project's repository.
  #
  # Returns an Array of tasks.
  def public_tasks
    @public_tasks ||= begin
      tasks.reject { |t| t.description.empty? || t.description =~ /^\[internal\]/ }
    end
  end

  # The hidden and internal task list for this project's repository.
  #
  # Returns an Array of tasks.
  def hidden_tasks
    @hidden_tasks ||= begin
      tasks.select { |t| t.description.empty? || t.description =~ /^\[internal\]/ }
    end
  end

  # Execute a capistrano command.
  #
  # args - An Array of arguments which will be passed to the Cap command.
  def cap(args = [])
    @_cap = nil
    
    FileUtils.chdir repo.path do
      @_cap = Capistrano::CLI.parse(%W(-f Capfile -Xx -l STDOUT) + args).execute!
    end
    
    @_cap
  end
  
  # Run git pull on the repo, as long as the last pull was more than 15 mins ago.
  def pull
    if !pull_in_progress? && !pulled_at.nil? && (Time.now - pulled_at) > 900
      Resque.enqueue Project::PullRepo, id
    end
  end
  
  # Run git pull on the repo regardless of when it was last pulled.
  def pull!
    Resque.enqueue Project::PullRepo, id unless pull_in_progress?
  end


  private

    def tasks
      @tasks ||= cap.task_list(:all).sort_by(&:fully_qualified_name)
    end

    def clone_repo
      Resque.enqueue Project::CloneRepo, id
    end

    def remove_repo
      Resque.enqueue Project::RemoveRepo, id
    end

    def update_github_data
      self.github_data = github.to_hash
    end

end
