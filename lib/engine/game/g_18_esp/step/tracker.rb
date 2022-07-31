# frozen_string_literal: true

require_relative '../../../step/tracker'

module Engine
  module Game
    module G18ESP
      module Tracker
        include Engine::Step::Tracker
        def potential_tiles(entity, hex)

          colors = potential_tile_colors(entity, hex)
          @game.tiles
            .select { |tile| @game.tile_valid_for_phase?(tile, hex: hex, phase_color_cache: colors)  && tile_valid_for_entity(entity, tile)}
            .uniq(&:name)
            .select { |t| @game.upgrades_to?(hex.tile, t) }
            .reject(&:blocks_lay)
        end

        def tile_valid_for_entity(entity, tile)
            @game.north_corp?(entity) ? tile.paths.any? { |p| p.track == :narrow } : tile.paths.any? { |p| p.track == :broad } 
        end
      end
    end
  end
end
