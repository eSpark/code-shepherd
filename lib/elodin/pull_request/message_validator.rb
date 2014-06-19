module Elodin
  class PullRequest
    class MessageValidator
      def initialize(exit_status, contents)
        @exit_status, @contents = exit_status, contents
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
