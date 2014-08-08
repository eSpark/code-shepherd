require 'thor'
require 'shepherd'

class Ard < Thor
  desc "pr TARGET", "Open a pull request against the target branch (master by default)"
  def pr(target = "master")
    Shepherd::PullRequest.new(target).open!
  end
end
