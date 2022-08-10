# frozen_string_literal: true

require_relative '../../../round/operating'

module Engine
  module Game
    module G18ESP
      module Round
        class Operating < Engine::Round::Operating
          attr_accessor :mea_hex
        end
      end
    end
  end
end
