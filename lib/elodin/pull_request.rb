module Elodin
  class PullRequest
    attr_reader :target_branch
    def initialize(target_branch)
      @target_branch = target_branch
    end

    def has_differences?
      differences.length > 0
    end

    def open!
      if has_differences?
        Elodin.logger.debug("Executing #{pr_command}")
        #`#{pr_command}`
      else
        raise LocalWorkflowError.new("The are no git differences between #{GitBranch.current} and #{target_branch}.")
      end
    end

    protected

    def pr_command
      # pbcopy copies to the clipboard for easy use
      "hub pull-request -b #{target_branch} -F \"#{commit_message.path}\" | pbcopy "
    end

    def differences
      GitBranch.changes(target_branch)
    end

    def commit_message
      @commit_message ||= CommitMessage.new(commit_data).acquire!
    end

    def commit_data
      {differences: differences, target_branch: target_branch}
    end
  end
end
