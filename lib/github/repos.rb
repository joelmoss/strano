class Github
  class Repos < Github::Base
    
    delegate :empty?, :in_groups, :to => :all
    
    def all
      @all ||= get "/user/repos"
    end
    
    def each
      all.each { |o| yield o }
    end
  
  end
end