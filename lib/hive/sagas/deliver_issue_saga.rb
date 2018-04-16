require 'hive/sagas/base'

module Hive
  module Sagas
    class DeliverIssueSaga < Base
      def initialize()
        # TO-DO fetch from YAML?
        transactions = { transactions: [
          { action: :create_label },
          { action: :create_issue_entitlement },
          { action: :update_label }
        ] }

        super(transactions)
      end

      def create_label
        puts "create_label"
      end

      def create_issue_entitlement
        puts "create_issue_entitlement"
      end

      def update_label
        raise StandardError

        puts "update_label"
      end

      def rollback_create_label
        puts "rollback_create_label"
      end

      def rollback_create_issue_entitlement
        puts "rollback_create_issue_entitlement"
      end

      def rollback_update_label
        puts "rollback"
      end
    end
  end
end
