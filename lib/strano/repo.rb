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
      repo.git.fs_mkdir('..') if !repo.git.fs_exist?('..')
      repo.git.clone({:timeout => false}, url, repo.path)
      repo
    end

    # Pull a cloned repo.
    #
    # url - The SSH URL of the git repository that this local repo is cloned from.
    #
    # Returns Boolean true if the repo was successfully removed.
    def self.pull(url)
      repo = new(url)
      repo.git.pull({:timeout => false, :chdir => repo.path, :base => false})
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
      Strano.clone_path
    end

    def path
      File.join root_path, user_name, repo_name
    end

    def refs
      if @refs
        return @refs
      else
        branches = []
        tags = []

        str = git.send(:'ls-remote', {:timeout => false, :base => false}, ssh_url)
        str.split("\n").each do |ref|
          if %r|refs/heads/(?<branch>[^^{}]*)$| =~ ref
            branches << branch
          elsif %r|refs/tags/(?<tag>[^^{}]*)$| =~ ref
            tags << tag
          end
        end

        @refs = {
          branches: branches.uniq.reverse,
          tags: tags.uniq.reverse
        }
      end
    end

    # Returns an Array of all branches, remote and local.
    def branches
      refs[:branches]
    end

    # Returns an Array of all tags.
    def tags
      refs[:tags]
    end

    def git
      @git ||= Grit::Git.new(path)
    end

    def exists?
      git.fs_exist? '.'
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
