class Github
  class Orgs < Github::Base
    
    def all
      get "/user/orgs"
    end
    
    def each
      all.each do |org|
        next unless Strano.allow_organizations_include?(org.login)
        yield Github::Org.new(@access_token, org)
      end
    end
  
  end
end