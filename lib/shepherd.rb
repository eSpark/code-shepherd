require 'shepherd/git_branch'
require 'shepherd/pull_request'
require 'shepherd/pull_request/commit_message'
require 'shepherd/pull_request/message_writer'
require 'shepherd/pull_request/message_validator'
require 'logger'

module Shepherd
  class LocalWorkflowError < StandardError; end

  def logger
    @logger ||= Logger.new(STDOUT)
  end

  class << self
    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
