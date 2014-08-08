require 'spec_helper'

module Shepherd
  class PullRequest
    RSpec.describe MessageValidator do
      let(:text) { "stuff @arsduo plz @barooo plz" }
      let(:validator) { MessageValidator.new(text) }

      context "validating a message" do
        context "if it's valid" do
          it "returns true" do
            expect(validator).to be_valid
          end

          it "has no error message" do
            expect(validator.errors).to be_nil
          end
        end

        context "if there are problems" do
          let(:text) { "stuff" }

          it "returns false" do
            expect(validator).not_to be_valid
          end

          it "has no error message" do
            expect(validator.errors).not_to be_nil
          end
        end
      end
    end
  end
end
