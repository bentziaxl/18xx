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

            @game.add_fc_token(action.tile, action.hex)
          end
        end
      end
    end
  end
end
