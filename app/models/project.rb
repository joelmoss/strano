class Project < ActiveRecord::Base
  
  belongs_to :user
  
  after_create :clone_repo
  
  
  private
  
    def clone_repo
      CLONE_QUEUE << url
    end
  
end
