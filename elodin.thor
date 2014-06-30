require 'thor'
require 'erb'
require 'ostruct'
require 'elodin'

class Elodin < Thor
  desc "pr TARGET", "Open a pull request against the target branch (master by default)"
  def pr(target = "master")
    PullRequest.new(target).open!
  end
end


