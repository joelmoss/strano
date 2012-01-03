class Github
  class Org < Github::Base
    
    def initialize(access_token, org_data)
      @access_token, @org_data = access_token, org_data
    end
    
    def repos
      @repos ||= get "/orgs/#{org_name}/repos"
    end
    
    def org_name
      @org_data.login
    end
    
    def method_missing(method, *args, &block)
      return super unless @org_data.respond_to?(method)
      @org_data.send method, *args, &block
    end
  
  end
end