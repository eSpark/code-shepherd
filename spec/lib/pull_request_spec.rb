require 'spec_helper'

module Elodin
  RSpec.describe PullRequest do
    let(:target_branch) { Faker::Lorem.word }
    let(:pr) { PullRequest.new(target_branch) }

    before :each do
      allow(GitBranch).to receive(:changes).with(target_branch).and_return([1])
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
        let(:message) { double("Commit Message", path: Faker::Lorem.word) }

        before :each do
          allow(pr).to receive(:has_differences?).and_return(true)
          allow(PullRequest::CommitMessage).to receive(:acquire!).and_return(message)
        end

        it "executes the right command" do
          expect_any_instance_of(Object).to receive(:`).with(
            "hub pull-request #{target_branch} --file #{message.path}"
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
