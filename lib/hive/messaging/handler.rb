require 'hive/messaging/components/rabbitmq'

module Hive
  module Messaging
    class Handler
      ADAPTER = :rabbitmq

      class << self
        def call(queue, adapter=ADAPTER)
          get_component(queue, adapter)
        end

        private

        def get_component(queue, adapter)
          "Hive::Messaging::Components::#{adapter.capitalize}"
            .constantize
            .new(queue)
        end
      end
    end
  end
end
