require 'hive/sagas/deliver_issue_saga'
require 'hive/sagas/unit'

module Hive
  module Sagas
    class Base
      attr_accessor :log, :status, :transactions, :current_step

      def initialize(attrs={})
        @log = []
        @transactions = attrs.fetch(:transactions) { [] }
        pending
      end

      def call
        begin
          iterate_and_run_transactions
        rescue StandardError => e
          rollback
        else
          saga_done
        ensure
          @current_step = nil
        end
        self
      end

      private

      def iterate_and_run_transactions
        @transactions.each do |transaction|
          run(transaction[:action],
              transaction[:rollback] || "rollback_#{transaction[:action]}"
          )
        end
      end

      def run(action, rollback)
        run_transaction_for(action, rollback)

        self
      end

      def register_step(action, rollback)
        @current_step = Unit.new(
          action: action, rollback: rollback
        ).tap do |step|
          @log.push(step)
        end
      end

      def run_transaction_for(action, rollback)
        register_step(action, rollback)
        @current_step.running

        send action

        @current_step.done
      end

      def rollback
        begin
          mark_step_as_error
          begin_rollback
          process_rollback
        rescue StandardError => e
          @status = 'ERROR'
        else
          end_rollback
        end

        self
      end

      def process_rollback
        steps_to_rollback.each do |step|
          @current_step = step
          run_rollback_for_current_step
        end
      end

      def run_rollback_for_current_step
        @current_step.rollingback
        send @current_step.rollback
        @current_step.rolledback
      end

      def steps_to_rollback
        @log[(0..[0, @log.index(@current_step) - 1].max)].reverse
      end

      def mark_step_as_error
        @current_step.error
      end

      def begin_rollback
        @status = 'ROLLINGBACK'
      end

      def end_rollback
        @status = 'ROLLEDBACK'
      end

      def pending
        @status = 'PENDING'
      end

      def saga_done
        @status = 'DONE'
      end
    end
  end
end