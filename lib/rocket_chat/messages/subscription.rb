module RocketChat
  module Messages
    #
    # Rocket.Chat Subscriptions
    #
    class Subscription
      #
      # @param [Session] session Session
      #
      def initialize(session)
        @session = session
      end

      #
      # subscriptions.get REST API
      # @param [String] updated_since Rocket.Chat updatedSince
      # @return [RocketChat::Subscription]
      # @raise [HTTPError, StatusError]
      #
      def get(updated_since: nil)
        response = session.request_json(
          '/api/v1/subscriptions.get',
          body: { updatedSince: updated_since }
        )
        RocketChat::Subscription.new response if response['success']
      end

      #
      # subscriptions.read REST API
      # @param [String] rid
      # @return [RocketChat::Subscription]
      # @raise [HTTPError, StatusError]
      #
      def read(rid:)
        response = session.request_json(
            '/api/v1/subscriptions.read',
            method: :post,
            body: { rid: rid }
        )
        RocketChat::Subscription.new response if response['success']
      end

      private

      attr_reader :session
    end
  end
end
