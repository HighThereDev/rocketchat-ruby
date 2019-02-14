module RocketChat
  #
  # Rocket.Chat Info
  #
  class Subscription
    # Raw info data
    attr_reader :data

    #
    # @param [Hash] data Raw info data
    #
    def initialize(data)
      @data = Util.stringify_hash_keys data
    end

    # Updated data
    def update
      data['update']
    end

    # Removed data
    def remove
      data['remove']
    end

    def success
      data['success']
    end
  end
end
