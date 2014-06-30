require 'thor'
require 'erb'
require 'ostruct'
require 'elodin'

class Elo < Thor
  desc "pr TARGET", "Open a pull request against the target branch (master by default)"
  def pr(target = "master")
    Elodin::PullRequest.new(target).open!
  end
end
