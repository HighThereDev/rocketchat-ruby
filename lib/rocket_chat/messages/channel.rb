module RocketChat
  module Messages
    #
    # Rocket.Chat Channel messages
    #
    class Channel < Room
      include ListSupport
      include UserSupport

      #
      # channels.join REST API
      # @param [String] room_id Rocket.Chat room id
      # @param [String] name Rocket.Chat room name (coming soon)
      # @return [Boolean]
      # @raise [HTTPError, StatusError]
      #
      def join(room_id: nil, name: nil)
        session.request_json(
          '/api/v1/channels.join',
          method: :post,
          body: room_params(room_id, name)
        )['success']
      end

      #
      # channels.list REST API
      # @param [Integer] offset Query offset
      # @param [Integer] count Query count/limit
      # @param [Hash] sort Query field sort hash. eg `{ msgs: 1, name: -1 }`
      # @param [Hash] fields Query fields to return. eg `{ name: 1, ro: 0 }`
      # @param [Hash] query The query. `{ active: true, type: { '$in': ['name', 'general'] } }`
      # @return [Room[]]
      # @raise [HTTPError, StatusError]
      #
      def list(offset: nil, count: nil, sort: nil, fields: nil, query: nil)
        response = session.request_json(
          '/api/v1/channels.list',
          body: build_list_body(offset, count, sort, fields, query)
        )

        response['channels'].map { |hash| RocketChat::Room.new hash } if response['success']
      end

      #
      # channels.list.joined REST API
      # @param [Integer] offset Query offset
      # @param [Integer] count Query count/limit
      # @param [Hash] sort Query field sort hash. eg `{ msgs: 1, name: -1 }`
      # @param [Hash] fields Query fields to return. eg `{ name: 1, ro: 0 }`
      # @param [Hash] query The query. `{ active: true, type: { '$in': ['name', 'general'] } }`
      # @return [Room[]]
      # @raise [HTTPError, StatusError]
      #
      def list_joined(offset: nil, count: nil, sort: nil, fields: nil, query: nil)
        response = session.request_json(
          '/api/v1/channels.list.joined',
          body: build_list_body(offset, count, sort, fields, query)
        )

        response['channels'].map { |hash| RocketChat::Room.new hash } if response['success']
      end

      #
      # channels.history REST API
      # @param [String] room_id Rocket.Chat room id
      # @param [Integer] offset Query offset
      # @param [Integer] count Query count/limit
      # @param [Hash] sort Query field sort hash. eg `{ msgs: 1, name: -1 }`
      # @param [Boolean] unreads Get only unreads messages
      # @return [Message[]]
      # @raise [HTTPError, StatusError]
      #
      def history(room_id:, offset: nil, count: nil, sort: nil, unreads: false)
        response = session.request_json(
            '/api/v1/channels.history',
            body: build_list_joined_body(room_id, offset, count, sort, unreads)
        )

        response['messages'].map { |hash| RocketChat::Message.new hash } if response['success']
      end

      #
      # channels.online REST API
      # @param [String] room_id Rocket.Chat room id
      # @return [Users[]]
      # @raise [HTTPError, StatusError]
      #
      def online(room_id: nil, name: nil)
        response = session.request_json(
          '/api/v1/channels.online',
          body: room_params(room_id, name)
        )

        response['online'].map { |hash| RocketChat::User.new hash } if response['success']
      end

      #
      # channels.open REST API
      # @param [String] room_id Rocket.Chat room id
      # @return [Boolean]
      # @raise [HTTPError, StatusError]
      #
      def open(room_id:)
        session.request_json(
            '/api/v1/channels.open',
            method: :post,
            body: room_params(room_id, nil)
        )['success']
      end

      #
      # channels.setCustomFields REST API
      # @param [String] room_id Rocket.Chat room id
      # @param [String] name Rocket.Chat room name
      # @param [Hash] name Rocket.Chat custom fields
      # @return [Boolean]
      # @raise [HTTPError, StatusError]
      #
      def set_custom_fields(room_id: nil, name: nil, custom_fields:)
        session.request_json(
            '/api/v1/channels.setCustomFields',
            method: :post,
            body: build_custom_field_body(room_id, name, custom_fields)
        )['success']
      end

      # Keys for set_attr:
      # * [String] description A room's description
      # * [String] join_code Code to join a channel
      # * [String] purpose Alias for description
      # * [Boolean] read_only Read-only status
      # * [String] topic A room's topic
      # * [Strong] type c (channel) or p (private group)
      def self.settable_attributes
        %i[description join_code purpose read_only topic type]
      end
    end
  end
end
