module Elodin
  class PullRequest
    class MessageValidator
      attr_reader :exit_status, :message
      def initialize(exit_status, message)
        @exit_status, @message = exit_status, message
      end

      def valid?
        @exit_status == 0
      end

      def error
        "The editor did not exit successfully!" unless valid?
      end
    end
  end
end
