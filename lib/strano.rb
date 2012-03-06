require "strano/configuration"
require "strano/repo"

module Strano
  extend Configuration
  
  class RepositoryPathNotFound < StandardError; end
  class CapfileNotFound < StandardError; end
end