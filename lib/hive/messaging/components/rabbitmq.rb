require 'bunny'

module Hive
  module Messaging
    module Components
      class Rabbitmq
        attr_accessor :queue

        def initialize(queue)
          self.queue = queue
          configure
        end

        def pop
          conn = Bunny.new
          conn.start
          ch = conn.create_channel
          q = ch.queue(queue)
          ary = q.pop
          conn.stop
          ary
        end

        private

        def configure
          #TODO read from yaml
        end
      end
    end
  end
end
