require 'spec_helper'

class PullRequest
  RSpec.describe MessageValidator do
    let(:validator) { MessageValidator.new(exit_status, "stuff") }

    context "if it exits successfully" do
      let(:exit_status) { 0 }

      it "is valid" do
        expect(validator).to be_valid
      end

      it "has no error" do
        expect(validator.error).to be_nil
      end
    end

    context "if it exits successfully" do
      let(:exit_status) { 1 }

      it "isn't valid" do
        expect(validator).not_to be_valid
      end

      it "has an error message" do
        expect(validator.error).not_to be_nil
      end
    end
  end
end
