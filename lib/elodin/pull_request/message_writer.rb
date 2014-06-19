module Elodin
  class PullRequest
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
        File.open(tempfile_path, "w") do |f|
          f << template_content
        end
      end

      def tempfile_path
        "/tmp/#{GitBranch.current}-#{data[:target_sha]} pull request"
      end

      def erb_data
        data.merge(current_branch: GitBranch.current)
      end

      def template_content
        # http://stackoverflow.com/questions/1338960/ruby-templates-how-to-pass-variables-into-inlined-erb
        data_object = OpenStruct.new(erb_data)
        ERB.new(File.read("template.erb")).result(data_object.instance_eval { binding })
      end
    end
  end
end
