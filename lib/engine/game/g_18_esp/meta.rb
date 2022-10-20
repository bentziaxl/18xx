# frozen_string_literal: true

require_relative '../meta'

module Engine
  module Game
    module G18ESP
      module Meta
        include Game::Meta

        DEV_STAGE = :prealpha

        GAME_SUBTITLE = 'Spain'
        GAME_DESIGNER = 'Lonny Orgler and Enrique Trigueros'
        GAME_LOCATION = 'Spain'
        GAME_PUBLISHER = nil
        GAME_RULES_URL = ''
        GAME_INFO_URL = ''

        PLAYER_RANGE = [3, 6].freeze

        OPTIONAL_RULES = [
          {
            sym: :pajares_broad,
            short_name: 'Pajares mountain pass MUST be built with iberian width gauge',
            players: [3, 4, 5, 6],
          },
        ].freeze
      end
    end
  end
end
