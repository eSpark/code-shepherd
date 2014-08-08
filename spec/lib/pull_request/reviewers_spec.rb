require 'spec_helper'

module Shepherd
  class PullRequest
    RSpec.describe Reviewers do
      let(:available) { Reviewers.available_reviewers }

      describe ".extract_from_text" do
        it "extracts the reviewers from some text" do
          text = "Reviewers:\n\n@abc plz\n@def plz"
          reviewers = Reviewers.extract_from_text(text)
          expect(reviewers.reviewers).to eq(["abc", "def"])
        end

        it "properly parses commit messages w/o reviewers" do
          text = "Deleting and Adding work, no lookahead support yet. \r\n\r\nDeleting is instantaneous for now.  A safe guard is probably a good idea to implement in case accidental deletions happen. \r\n\r\nAdding stuff is done by typing the IDs directly into the textbox.  Attach \"s\" to the beginning of an ID to represent a section. \r\nEX: '1,s2,3' will add students with ID 1 and 3, and section with ID 2.  \r\nThis was made with the assumption that a lookahead will be used with it without allowing users to edit the box directly.  As it is now it presents obvious security issues.  \r\n\r\nNo major stylistic modifications have been made yet.  "
          reviewers = Reviewers.extract_from_text(text)
          expect(reviewers.reviewers).to eq([])
        end
      end

      describe "#valid?" do
        it "returns false if there are < 2 reviewers" do
          expect(Reviewers.new([available.first])).not_to be_valid
        end

        it "returns false if one of the names is bad" do
          expect(
            Reviewers.new([available.first, Faker::Company.bs])
          ).not_to be_valid
        end

        it "returns true otherwise" do
          expect(Reviewers.new(available[1..3])).to be_valid
        end
      end

      describe "#problems" do
        it "returns something appropriate if there are too few reviewers" do
          expect(
            Reviewers.new([available.first]).problems
          ).to include("You must specify at least 2 reviewers.")
        end

        it "returns an appropriate message if a name is bad" do
          bad_name = Faker::Company.bs
          expect(
            Reviewers.new([available.first, bad_name]).problems
          ).to include("The following reviewers are invalid: #{bad_name}")
        end

        it "returns nil otherwise" do
          expect(Reviewers.new(available[1..3]).problems).to be_nil
        end
      end

    end
  end
end
