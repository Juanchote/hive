module Hive
  module Configurators
    class Base
      class << self
        def config_for(workflow)
          {
            jobs: [
              :get_count_issue_subscriptions_by_publication_id,
              #:fetch_paginated_issue_subscriptions,
              #:check_auto_renew_issue_subscription,
              #:deliver_issue_to_subscription,
              # :update_issue_checkout,
              #:send_notification_to_users
            ]
          }
        end
      end
    end
  end
end
