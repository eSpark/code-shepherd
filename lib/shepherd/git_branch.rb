module Shepherd
  class GitBranch
    def self.current
      `#{branch_command}`.chomp.tap do |branch|
        Shepherd.logger.debug("#{branch_command}: #{branch}")
      end
    end

    def self.changes(target_branch = "master")
      command = diff_command(target_branch)
      `#{command}`.chomp.split("\n").tap do |deltas|
        Shepherd.logger.debug("#{command}: \n\t#{deltas.join("\n\t")}")
      end
    end

    def self.diff_command(target_branch)
      "git log #{target_branch}..HEAD --oneline"
    end

    def self.branch_command
      "git rev-parse --abbrev-ref HEAD"
    end
  end
end
