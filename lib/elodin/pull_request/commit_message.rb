module Elodin
  class PullRequest
    class CommitMessage
      attr_reader :message_data
      def initialize(**message_data)
        @message_data = message_data
      end

      def message
        MessageWriter.new(**message_data)
      end

      def acquire!
        launch_editor!
        editing_result = MessageValidator.new(exit_status, message)
        if editing_result.valid?
          message
        else
          raise LocalWorkflowError.new(editing_result.error)
        end
      end

      protected

      def launch_editor!
        `"#{ENV["EDITOR"]}" "#{message.path}"`
      end

      def exit_status
        $?.to_i
      end
    end

  end
end
