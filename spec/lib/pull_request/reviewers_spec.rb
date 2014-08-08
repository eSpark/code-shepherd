require 'spec_helper'

module Shepherd
  class PullRequest
    RSpec.describe Reviewers do
      let(:available) { Reviewers.available_reviewers }

      describe ".reviewers_from_text" do
        it "extracts the reviewers from some text" do
          text = "Reviewers:\n\n@abc plz\n@def plz"
          reviewers = Reviewers.reviewers_from_text(text)
          expect(reviewers.reviewers).to eq(["abc", "def"])
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
