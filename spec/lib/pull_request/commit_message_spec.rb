require 'spec_helper'

module Shepherd
  class PullRequest
    RSpec.describe CommitMessage do
      let(:message_data) { {commits: [double], target_sha: "foo"} }
      let(:commit_message) { CommitMessage.new(**message_data) }
      let(:editor_command) { "\"#{ENV["EDITOR"]}\" \"#{path}\"" }

      before :each do
        allow(GitBranch).to receive(:current).and_return(Faker::Lorem.word)
      end

      describe "#message" do
        it "returns a MessageWriter with the right configuration" do
          message_file = commit_message.message
          expect(message_file.data).to eq(message_data)
        end
      end

      describe "#acquire!" do
        let(:path) { Faker::Lorem.word }
        let(:message) { double("message", contents: "foo", path: path) }
        let(:exit_status) { rand }
        let(:validity) { true }

        before :each do
          allow(commit_message).to receive(:message).and_return(message)

          # you can't really stub $?
          allow_any_instance_of(MessageValidator).to receive(:valid?) do |validator|
            expect(validator.message).to eq(message.contents)
            validity
          end
          # don't actually launch the editor
          allow_any_instance_of(Object).to receive(:system).and_return(true)
        end

        it "launches the editor" do
          editor = ENV["EDITOR"]
          ENV["EDITOR"] = Faker::Lorem.word
          expect_any_instance_of(Object).to receive(:system).with(editor_command).and_return(true)
          commit_message.acquire!
          ENV["EDITOR"] = editor
        end

        context "if the result is valid" do
          it "returns the message" do
            expect(commit_message.acquire!).to eq(message)
          end
        end

        context "if the process exits with problems" do
          let(:erraor) { Faker::Company.bs }

          before :each do
            allow_any_instance_of(Object).to receive(:system).and_return(false)
          end

          it "raises a LocalWorkflowError with the error" do
            expect { commit_message.acquire! }.to raise_exception(LocalWorkflowError) do |err|
              expect(err.message).to include(editor_command)
            end
          end
        end

        context "if the result is invalid" do
          let(:validity) { false }

          it "raises a LocalWorkflowError" do
            expect { commit_message.acquire! }.to raise_exception(LocalWorkflowError)
          end
        end
      end
    end
  end
end
