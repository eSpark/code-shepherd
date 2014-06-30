require 'spec_helper'

module Elodin
  class PullRequest
    RSpec.describe MessageValidator do
      let(:validator) { MessageValidator.new("stuff") }

      context "if it exits successfully" do
        it "returns true" do
          expect(validator).to be_valid
        end

        it "has no error message" do
          expect(validator.error).to be_nil
        end
      end
    end
  end
end
