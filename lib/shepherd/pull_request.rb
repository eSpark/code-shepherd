module Shepherd
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
        Shepherd.logger.debug("Executing #{pr_command}")
        `#{pr_command}`
        puts "Your pull request has been opened! You can paste the link into Hipchat directly."
      else
        raise LocalWorkflowError.new("The are no git differences between #{GitBranch.current} and #{target_branch}.")
      end
    end

    protected

    def pr_command
      # pbcopy copies to the clipboard for easy use
      "hub pull-request -b #{target_branch} -h #{GitBranch.current} -F \"#{message.path}\" | pbcopy "
    end

    def differences
      GitBranch.changes(target_branch)
    end

    def message
      @message ||= CommitMessage.new(commit_data).acquire!
    end

    def commit_data
      {differences: differences, target_branch: target_branch}
    end

    def commit_description_path
      message.path
    end
  end
end
