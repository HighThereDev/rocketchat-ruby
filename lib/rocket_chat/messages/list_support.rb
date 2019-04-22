module RocketChat
  module Messages
    #
    # Support methods for *.list calls
    #
    module ListSupport
      private

      def build_list_body(offset, count, sort, fields, query = nil)
        body = {}

        body[:offset] = offset.to_i if offset.is_a? Integer
        body[:count] = count.to_i if count.is_a? Integer
        [[:sort, sort], [:fields, fields], [:query, query]].each do |field, val|
          case val
          when Hash
            body[field] = val.to_json
          when String
            body[field] = val
          end
        end

        body
      end

      def build_list_joined_body(room_id, offset, count, sort, unreads)
        body = {}

        body[:roomId] = room_id
        body[:offset] = offset.to_i if offset.is_a? Integer
        body[:count] = count.to_i if count.is_a? Integer
        body[:unreads] = unreads if unreads.is_a?(TrueClass) || unreads.is_a?(FalseClass)

        [[:sort, sort]].each do |field, val|
          case val
          when Hash
            body[field] = val.to_json
          when String
            body[field] = val
          end
        end

        body
      end

      def build_custom_field_body(room_id, name, custom_fields)
        body = room_params(room_id, name)
        body[:customFields] = custom_fields

        body
      end
    end
  end
end
