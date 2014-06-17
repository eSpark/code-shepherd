require 'spec_helper'

RSpec.describe GitBranch do
  describe ".current" do
    it "returns the current branch" do
      expect(GitBranch.current).to eq(
        Git.open(Dir.pwd.gsub(/elodin.*/, "elodin")).lib.branch_current
      )
    end
  end
end
