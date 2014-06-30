require 'elodin/git_branch'
require 'elodin/pull_request'
require 'elodin/pull_request/commit_message'
require 'elodin/pull_request/message_writer'
require 'elodin/pull_request/message_validator'
require 'logger'

module Elodin
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
