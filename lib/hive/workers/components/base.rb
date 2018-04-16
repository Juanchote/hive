require 'redis'
require 'bunny'
require 'hive/configurators/base'

require 'hive/sagas/deliver_issue_saga'
require 'hive/sagas/unit'

module Hive
  module Workers
    module Components
      class Base
        attr_accessor :message, :config, :delivery_info, :metadata, :payload, :queue

        @queue = :default

        def self.perform(queue, exchange="")
          new(queue, exchange).call
        end

        def initialize(queue, exchange="")
          get_message(queue, exchange)

          load_preferences
        end

        def call
          do_something
        end

        private

        def load_preferences
          # TODO something with the configurator
        end

        def get_message(queue, exchange)
          conn = Bunny.new
          conn.start
          ch = conn.create_channel
          q = ch.queue(queue)
          self.delivery_info, self.metadata, self.payload = q.pop
          conn.stop
        end

        def do_something

        end
      end
    end
  end
end