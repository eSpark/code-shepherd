class GitBranch
  def self.current
    `git rev-parse --abbrev-ref HEAD`.chomp
  end

  def self.changes(target_sha = "master")
    `#{diff_command(target_sha)}`.chomp.split("\n")
  end

  def self.diff_command(target_sha)
    "git log #{target_sha}..HEAD --oneline"
  end
end

