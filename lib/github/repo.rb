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

    def hook(url, secret)
      post "/repos/#{user_name}/#{repo_name}/hooks", {
        "name" => "web",
        "active" => true,
        "config" => {
          "url" => url,
          "secret" => secret,
          "content_type" => "json"
        }
      }
    end


    private
    
      def repo
        @repo ||= get "/repos/#{user_name}/#{repo_name}"
      end
  
  end
end
