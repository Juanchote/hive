module Hive
  module Sagas
    class Unit < ::Hashie::Dash
      include Hashie::Extensions::Coercion
      include Hashie::Extensions::MethodAccess
      include Hashie::Extensions::IndifferentAccess

      property :action, required: true
      property :rollback, required: true
      property :status, default: 'PENDING'

      def pending
        self.status = 'PENDING'
      end

      def running
        self.status = 'RUNNING'
      end

      def error
        self.status = 'ERROR'
      end

      def done
        self.status = 'DONE'
      end

      def rollingback
        self.status = 'ROLLINGBACK'
      end

      def rolledback
        self.status = 'ROLLEDBACK'
      end
    end
  end
end
