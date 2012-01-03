module Strano
  class Repo

    attr_accessor :ssh_url, :user_name, :repo_name

    # Initialize a local repository.
    #
    # url - The SSH URL of the git repository that this local repo is cloned from.
    def initialize(url)
      @ssh_url = url
      @user_name, @repo_name = url.scan(/.+:(?:(.+)\/(.+))\.git$/).flatten
    end

    # Clone a remote repo at the given url.
    #
    # url - The SSH URL of the git repository that this local repo is cloned from.
    #
    # Returns the newly clone Strano::Repo object.
    def self.clone(url)
      repo = new(url)
      repo.git.fs_mkdir('..')
      repo.git.clone({:timeout => false}, url, repo.path)
      repo
    end

    # Remove a cloned repo from the filesystem.
    #
    # url - The SSH URL of the git repository that this local repo is cloned from.
    #
    # Returns Boolean true if the repo was successfully removed.
    def self.remove(url)
      repo = new(url)
      repo.git.fs_delete('../')
      !repo.git.fs_exist?('../')
    end

    def root_path
      ENV['STRANO_CLONE_PATH'] || Rails.root.join("vendor/repos")
    end

    def path
      File.join root_path, user_name, repo_name
    end

    def git
      @git ||= Grit::Git.new(path)
    end

    # Is this repo cloned to the local file system?
    #
    # Returns a Boolean true if it has been cloned.
    def cloned?
      git.fs_exist? '.git'
    end

    # Is this repo capified? Meaning does it have a Capfile in its root.
    #
    # Returns a Boolean true if it has been capified.
    def capified?
      git.fs_exist? 'Capfile'
    end

  end
end