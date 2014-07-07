module Shepherd
  class PullRequest
    class MessageValidator
      attr_reader :message
      def initialize(message)
        @message = message
      end

      def valid?
        true
      end

      def error
      end
    end
  end
end
