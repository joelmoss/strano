class Github
  class Key < Github::Base
  
    def create(title, key)
      post '/user/keys', :title => title, :key => key
    end
      
  end
end