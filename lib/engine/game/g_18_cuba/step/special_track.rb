# frozen_string_literal: true

require_relative '../../../step/special_track'
require_relative 'lay_tile_check'

module Engine
  module Game
    module G18Cuba
      module Step
        include LayTileCheck
        class SpecialTrack < Engine::Step::SpecialTrack
          def hex_neighbors(entity, hex)
            return unless (ability = abilities(entity))
            return if !ability.hexes&.empty? && !ability.hexes&.include?(hex.id)

            corp = entity.corporation? ? entity : @game.current_entity

            return if ability.type == :tile_lay && ability.reachable && !@game.graph_for_entity(corp).connected_hexes(corp)[hex]

            @game.hex_by_id(hex.id).neighbors.keys
          end
        end
      end
    end
  end
end
