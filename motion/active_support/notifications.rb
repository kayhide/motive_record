module ActiveSupport
  module Notifications
    def self.instrumenter
      @instrumenter ||= Instrumenter.new
    end

    class Instrumenter
      def instrument *args
        yield
      end
    end
  end
end
