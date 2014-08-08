require 'shepherd/pull_request/reviewers'

module Shepherd
  class PullRequest
    class MessageValidator
      attr_reader :message

      def initialize(message)
        @message = message
      end

      def valid?
        reviewers.valid?
      end

      def errors
        reviewers.problems
      end

      protected

      def reviewers
        @reviewers ||= Reviewers.extract_from_text(message)
      end
    end
  end
end
