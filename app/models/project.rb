require 'capistrano/cli'
require "kernel"

class Project < ActiveRecord::Base

  # The github data will be serialzed as a Hash.
  serialize :github_data

  belongs_to :user
  has_many :jobs, :dependent => :destroy

  validate :url, :presence => true, :uniqueness => { :case_sensitive => false }

  after_create :clone_repo
  before_save :update_github_data
  after_destroy :remove_repo

  delegate :user_name, :repo_name, :cloned?, :capified?, :to => :repo
  delegate :html_url, :description, :organization, :to => :github_data


  def to_s
    "#{user_name}/#{repo_name}"
  end

  def organization?
    organization.present?
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

  def tasks(include_empty_and_internal = false)
    @tasks ||= begin
      _tasks = cap(%W(-t)).task_list(:all)
      unless include_empty_and_internal
        _tasks.reject! { |t| t.description.empty? || t.description =~ /^\[internal\]/ }
      end
      _tasks
    end
  end

  # Execute a capistrano command.
  #
  # args - An Array of arguments which will be passed to the Cap command.
  def cap(args = [])
    @cap, args = nil, %W(-f Capfile -Xx -l STDOUT) + args
    FileUtils.chdir repo.path do
      @cap = Capistrano::CLI.parse(args).execute!
    end
    @cap
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
