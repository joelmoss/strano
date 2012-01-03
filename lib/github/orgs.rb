class Github
  class Orgs < Github::Base
    
    def all
      get "/user/orgs"
    end
    
    def each
      all.each { |org| yield Github::Org.new(@access_token, org) }
    end
  
  end
end