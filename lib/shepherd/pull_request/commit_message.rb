module Shepherd
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
        if result = launch_editor!
          editing_result = MessageValidator.new(message)
          if editing_result.valid?
            message
          else
            raise LocalWorkflowError.new(editing_result.error)
          end
        else
          raise LocalWorkflowError.new("The command #{editor_command} failed!")
        end
      end

      protected

      def launch_editor!
        system(editor_command).tap do |result|
          Shepherd.logger.debug("#{editor_command}: #{result}")
        end
      end

      def editor_command
        "\"#{ENV["EDITOR"]}\" \"#{message.path}\""
      end
    end
  end
end
