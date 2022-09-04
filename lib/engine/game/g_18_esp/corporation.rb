# frozen_string_literal: true

module Engine
  module Game
    module G18ESP
      class Corporation < Engine::Corporation
        attr_reader :destination

        def initialize(sym:, name:, **opts)
          @destination = opts[:destination]
          super
        end
      end
    end
  end
end
