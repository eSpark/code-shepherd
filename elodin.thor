require 'thor'
require 'erb'
require 'ostruct'
require File.join(File.dirname(__FILE__), 'lib/elodin')

class Elodin < Thor
  desc "pr TARGET", "Open a pull request against the target branch (master by default)"
  def pr(target = "master")
    PullRequest.new(target).open!
  end
end
