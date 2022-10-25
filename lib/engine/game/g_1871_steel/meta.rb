# frozen_string_literal: true

require_relative '../meta'

module Engine
  module Game
    module G1871STEEL
      module Meta
        include Game::Meta

        DEV_STAGE = :prealpha

        GAME_TITLE = '1871 Steel Cities'
        GAME_DESIGNER = 'Fred Campbell'
        GAME_LOCATION = 'Northeastern USA and Southeastern Canada'

        PLAYER_RANGE = [3,5].freeze
      end
    end
  end
end
