require 'cucumber/formatter/pretty'

module AngryPickle

  FAILED_IMG  = "/images/failed.png"
  PENDING_IMG = "/images/pending.png"
  PASSED_IMG  = "/images/passed.png"

  def self.included(base)
    base.class_eval do

      alias print_stats_original print_stats

      def print_stats(features, profiles = [])

        print_stats_original(features, profiles)

        failed  = step_mother.scenarios(:failed).count
        passed  = step_mother.scenarios(:passed).count
        pending = step_mother.scenarios(:pending).count
        message = %{#{passed} passed\n#{failed} failed\n#{pending} pending}

        dir = Gem.searcher.find('angry-pickle').full_gem_path

        img = failed > 0 ? FAILED_IMG : pending > 0 ? PENDING_IMG : PASSED_IMG

        system "growlnotify -t 'Cucumber Scenarios' --image '#{dir}#{img}' -m '#{message}'"

      end

    end
  end
end

class Cucumber::Formatter::Pretty
  include AngryPickle
end