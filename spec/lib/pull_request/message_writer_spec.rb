require 'spec_helper'

module Elodin
  class PullRequest
    RSpec.describe MessageWriter do
      let(:target_sha) { Faker::Lorem.words(2).join("_") }
      let(:commits) { 3.times.map {|f| Faker::Lorem.word } }
      let(:data) { {
        target_sha: target_sha,
        commits: commits
      } }
      let(:writer) { MessageWriter.new(data) }
      let(:current_branch) { Faker::Lorem.words(2).join("_") }

      before :each do
        allow(GitBranch).to receive(:current).and_return(current_branch)
      end

      after :each do
        File.delete(writer.path)
      end

      describe "#contents" do
        it "returns the content of the file" do
          expect(writer.contents).to eq(File.read(writer.path))
        end

        it "respects changes" do
          File.open(writer.path, "a") do |f|
            f << rand
          end
          expect(writer.contents).to eq(File.read(writer.path))
        end
      end

      describe "#path" do
        it "returns the path to a tempfile" do
          expect(File.exists?(writer.path)).to be true
        end

        it "is unique per branch" do
          path = writer.path
          allow(GitBranch).to receive(:current).and_return(Faker::Lorem.word)
          expect(path).not_to eq(MessageWriter.new(data).path)
        end

        it "is unique per branch" do
          expect(writer.path).not_to eq(
            MessageWriter.new(data.merge(target_sha: Faker::Company.bs))
          )
        end

        it "includes the template" do
          content = File.read(writer.path)
          expect(content).to include(current_branch)
          expect(content).to include(target_sha)
          commits.each do |c|
            expect(content).to include(c)
          end
        end
      end
    end
  end
end
