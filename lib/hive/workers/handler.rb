require 'hive/workers/components/base'

module Hive
  module Workers
    class Handler

      def self.call(queue, type, exchange="")
        set_component(type).perform(queue, exchange)
      end

      def self.async_call(queue, type, exchange="")
        Resque.enqueue(set_component(type),queue, exchange)
      end

      private

      def self.set_component(type)
        "Hive::Workers::Components::#{type.capitalize}".constantize
      end
    end
  end
end
