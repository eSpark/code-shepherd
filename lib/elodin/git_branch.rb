class GitBranch
  def self.current
    `git rev-parse --abbrev-ref HEAD`.chomp
  end
end

