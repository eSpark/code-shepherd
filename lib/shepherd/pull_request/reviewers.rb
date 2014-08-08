module Shepherd
  class PullRequest
    class Reviewers
      REQUIRED_REVIEWER_COUNT = 2

      def self.available_reviewers
        # hard-coded for now, we'll read from a file shortly
        # for now, we also allow you to choose yourself as a reviewer -- we'll
        # figure out a way to limit that for now, but we do also require more
        # than one reviewer
        [
          "arsduo",
          "barooo",
          "gnarmis",
          "kairuiwang",
          "kochalex",
          "lshepard",
          "mayalopuch",
          "mpstreeter",
          "nhatch",
          "spo11",
          "athenalo",
          "alicelocatelli",
          "khsia"
        ]
      end

      attr_reader :reviewers
      def initialize(reviewers)
        @reviewers = reviewers
      end

      def valid?
        !problems
      end

      def problems
        probs = [:error_on_reviewer_names, :error_on_number_of_reviewers].map do |error|
          self.send(error)
        end.compact
        probs unless probs.empty?
      end

      protected

      def error_on_number_of_reviewers
        if reviewers.length < REQUIRED_REVIEWER_COUNT
          "You must specify at least #{REQUIRED_REVIEWER_COUNT} reviewers."
        end
      end

      def error_on_reviewer_names
        invalid_reviewers = reviewers - Reviewers.available_reviewers
        if invalid_reviewers.length > 0
          "The following reviewers are invalid: #{invalid_reviewers.join(", ")}"
        end
      end
    end
  end
end
