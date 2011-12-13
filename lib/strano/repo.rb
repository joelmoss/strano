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
      repo.git.clone({}, url, repo.path)
      repo
    end
    
    def root_path
      ENV['STRANO_CLONE_PATH'] || Rails.root.join("vendor/repos")
    end
    
    def path
      File.join(root_path, user_name, repo_name)
    end
    
    def git
      @git ||= Grit::Git.new(path)
    end
    
  end
end