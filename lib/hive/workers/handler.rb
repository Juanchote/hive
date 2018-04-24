# frozen_string_literal: true
require 'hive/workers/components/base'
require 'redis'

module Hive
  module Workers
    class Handler

      def self.call(queue, exchange= '')
        get_component
          .call(queue, exchange)
      end

      class << self
        def get_component
          Hive::Workers::Components::Base
        end
      end
    end
  end
end
