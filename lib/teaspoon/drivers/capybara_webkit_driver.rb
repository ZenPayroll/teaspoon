begin
  require "capybara-webkit"
rescue LoadError
  Teaspoon.abort("Could not find Capybara Webkit. Install the capybara-webkit gem.")
end

module Teaspoon
  module Drivers
    class CapybaraWebkitDriver < Base
      def initialize(_options = nil)
      end

      def run_specs(runner, url)
        session.visit(url)

        session.document.synchronize(Teaspoon.configuration.driver_timeout.to_i) do
          done = session.evaluate_script("window.Teaspoon && window.Teaspoon.finished")
          (session.evaluate_script("window.Teaspoon && window.Teaspoon.getMessages()") || []).each do |line|
            runner.process("#{line}\n")
          end
          done
        end
      end

      private

      def session
        @session ||= Capybara::Session.new(:webkit)
      end
    end
  end
end
