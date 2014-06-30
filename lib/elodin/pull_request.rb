module Elodin
  class PullRequest
    attr_reader :target_branch
    def initialize(target_branch)
      @target_branch = target_branch
    end

    def has_differences?
      differences.length > 0
    end

    def differences
      GitBranch.changes(target_branch)
    end

    def open!
      if has_differences?
        message = CommitMessage.acquire!
        `hub pull-request #{target_branch} --file #{message.path}`
      else
        raise LocalWorkflowError.new("The are no git differences between #{GitBranch.current} and #{target_branch}.")
      end
    end
  end
end
