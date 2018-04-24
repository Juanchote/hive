# frozen_string_literal: true
require 'securerandom'
require 'json'
require "active_support/core_ext/hash/indifferent_access"

require 'hive/configurators/base'
require 'hive/messaging/handler'

module Hive
  module Workers
    module Components
      class Base
        attr_accessor :config, :delivery_info,
                    :metadata, :payload, :queue,
                    :event_handler, :type, :id,
                    :prev_id, :created_at, :ended_at,
                    :status, :error

        def self.call(queue, exchange = '')
          new(queue, exchange).call
        end

        def call
          do_something
        end

        def to_s
          #TODO serialize object
        end

        private

        def initialize(queue, exchange)
          start
          message
          configure
        end

        def configure
          self.config = Hive::Configurators::Base.config_for(type)
        end

        def message
          self.delivery_info, self.metadata, self.payload = event_handler.pop
          self.payload = parse_payload
          self.type = payload&.dig(:type)
        rescue JSON::ParserError, TypeError, Bunny::TCPConnectionFailedForAllHosts => e
          handle_exceptions(e)
        end

        def do_something
          #TODO do something
          done
        end

        def start
          self.id = SecureRandom.uuid
          self.status = 'Pending'
          self.created_at = DateTime.now
          self.event_handler = Hive::Messaging::Handler.call(queue)
        end

        def in_progress
          self.status = 'In progress'
        end

        def done
          self.ended_at = DateTime.now
          self.status = 'DONE'
        end

        def error
          self.status = 'ERROR'
        end

        def parse_payload
          ActiveSupport::HashWithIndifferentAccess.new(
            JSON.parse(payload)
          )
        end

        def handle_exceptions(e)
          self.error = [e.message].concat(e.backtrace).join("\n")
          done
          error
        end
      end
    end
  end
end