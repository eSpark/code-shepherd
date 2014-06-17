require 'thor'
require 'erb'
require 'ostruct'

class Elodin < Thor
  desc "pr TARGET", "Open a pull request against the target branch (master by default)"
  def pr(target = "master")
    # we want to make a new pull request using the template as specified in
    # .cli/pull_request_template.erb
    pull_request = PullRequest.new(target)
    if pull_request.has_differences?
      message_file = CommitMessage.new(pull_request.differences, target)
      `git pull_request #{target} -F #{message_file.path}`
    else
      puts "No difference found between HEAD and #{target}\
            (using #{pull_request.diff_command})"
      exit 1
    end
  end


  class PullRequest
    attr_reader :target_sha
    def initialize(target_sha)
      @target_sha = target_sha
    end

    def has_differences?
      differences.length > 0
    end

    def differences
      @differences ||= diff_command
    end

    def diff_command
      `git log #{target_sha}..HEAD --oneline`
    end

    def template_contents
      data = {
        commits: differences
      }
    end

    class CommitMessage
      attr_reader :commits, :target_sha
      def initialize(commits: nil, target_sha: nil)
        @commits = nil
        @target_sha = nil
      end

      def message
        MessageFile.new(
          commits: commits,
          target_sha: target_sha
        )
      end

      def acquire!
        launch_editor!
        editing_result = MessageValidator.new(exit_status, message.content)
        if editing_result.valid?
          message
        else
          puts editing_result.error
          exit 1
        end
      end

      protected

      def launch_editor!\
        `\`echo $EDITOR\` "#{message.path}"`
      end

      def exit_status
        $?.to_i
      end
    end

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

    class MessageWriter
      attr_reader :data
      def initialize(data)
        @data = data
      end

      def contents
        File.read(path)
      end

      def path
        ensure_tempfile
        tempfile_path
      end

      protected

      def ensure_tempfile
        generate_tempfile unless File.exists?(tempfile_path)
      end

      def generate_tempfile
        File.open(tempfile_path) do |f|
          f << template_content
        end
      end

      def tempfile_path
        "/tmp/#{data[:current_branch]}-#{data[:target_sha]} pull request"
      end

      def template_content
        # http://stackoverflow.com/questions/1338960/ruby-templates-how-to-pass-variables-into-inlined-erb
        erb_data = OpenStruct.new(@data)
        ERB.new(File.read("template.erb")).result(erb_data.instance_eval { binding })
      end
    end
  end
end
