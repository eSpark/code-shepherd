require 'spec_helper'

module Shepherd
  RSpec.describe PullRequest do
    let(:target_branch) { Faker::Lorem.word }
    let(:pr) { PullRequest.new(target_branch) }
    let(:changes) { [double] }

    before :each do
      allow(GitBranch).to receive(:changes).with(target_branch).and_return(changes)
      allow(GitBranch).to receive(:current).and_return(Faker::Lorem.word)
    end

    describe "#has_differences?" do
      it "returns true if there are git differences" do
        expect(pr).to have_differences
      end

      it "returns false if there are no differences" do
        expect(GitBranch).to receive(:changes).and_return([])
        expect(pr).not_to have_differences
      end
    end

    describe "open!" do
      context "if there are differences" do
        let(:contents) { Faker::Lorem.words(6).join("\n") }
        let(:message) {
          double("Commit Message", path: Faker::Lorem.word, message_contents: contents)
        }

        before :each do
          allow_any_instance_of(PullRequest::CommitMessage).to receive(:acquire!) do |msg|
            if msg.message_data == {differences: changes, target_branch: target_branch}
              message
            end
          end
        end

        it "executes the right command" do
          expect_any_instance_of(Object).to receive(:`).with(
            "hub pull-request -b #{target_branch} -h #{GitBranch.current} -m \"#{contents}\" | pbcopy "
          )
          pr.open!
        end
      end

      context "if there are no differences" do
        before :each do
          allow(pr).to receive(:has_differences?).and_return(false)
        end

        it "raises a LocalWorkflowError" do
          expect { pr.open! }.to raise_exception(LocalWorkflowError)
        end
      end
    end
  end
end
