require 'spec_helper'

module Elodin
  class PullRequest
    RSpec.describe CommitMessage do
      let(:message_data) { {commits: [double], target_sha: "foo"} }
      let(:commit_message) { CommitMessage.new(**message_data) }

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
        let(:message) { double("message", path: path) }
        let(:exit_status) { rand }
        let(:validity) { true }

        before :each do
          allow(commit_message).to receive(:message).and_return(message)

          # you can't really stub $?
          allow(commit_message).to receive(:exit_status).and_return(exit_status)
          allow_any_instance_of(MessageValidator).to receive(:valid?) do |validator|
            expect(validator.exit_status).to eq(exit_status)
            expect(validator.message).to eq(message)
            validity
          end
          # don't actually launch the editor
          allow_any_instance_of(Object).to receive(:`)
        end

        it "launches the editor" do
          editor = ENV["EDITOR"]
          ENV["EDITOR"] = Faker::Lorem.word
          allow_any_instance_of(Object).to receive(:`).with("\"#{ENV["EDITOR"]}\" \"#{path}\"")
          commit_message.acquire!
          ENV["EDITOR"] = editor
        end

        context "if the result is valid" do
          it "returns the message" do
            expect(commit_message.acquire!).to eq(message)
          end
        end

        context "if the result is invalid" do
          let(:validity) { false }
          let(:error) { Faker::Company.bs }

          before :each do
            allow_any_instance_of(MessageValidator).to receive(:error).and_return(error)
          end

          it "raises a LocalWorkflowError with the error" do
            expect { commit_message.acquire! }.to raise_exception(LocalWorkflowError) do |err|
              expect(err.message).to eq(error)
            end
          end
        end
      end
    end
  end
end
