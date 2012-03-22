require "strano/version"
require "strano/configuration"
require "strano/repo"

module Strano
  extend Configuration

  class ProjectCapError < StandardError; end

  class RepositoryPathNotFound < ProjectCapError; end
  class CapfileNotFound < ProjectCapError; end
  class CapistranoLoadError < ProjectCapError; end
end