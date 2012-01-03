class Github
  class Repo < Github::Base
    
    attr_accessor :user_name, :repo_name
  
    def initialize(access_token, user_name, repo_name)
      @access_token, @user_name, @repo_name = access_token, user_name, repo_name
    end

    def inspect
      repo
    end

    alias :to_hash :inspect


    private
    
      def repo
        @repo ||= get "/repos/#{user_name}/#{repo_name}"
      end
  
  end
end