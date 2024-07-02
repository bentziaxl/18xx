# frozen_string_literal: true

require_relative '../../../step/tracker'
require_relative '../../../step/track'
require_relative 'skip_fc'
require_relative 'lay_tile_check'

module Engine
  module Game
    module G18Cuba
      module Step
        class Track < Engine::Step::Track
          include SkipFc
          include LayTileCheck

          def lay_tile(action, extra_cost: 0, entity: nil, spender: nil)
            super

            return unless @game.fc_hex?(action.hex)
            return unless action.tile.color == :green

            token = @game.fc.find_token_by_type
            city = action.tile.cities.first
            city.place_token(@game.fc, token, cheater: true)
            action.tile.icons = []
            @log << "FC places a token in #{action.hex.id}"
          end
        end
      end
    end
  end
end
