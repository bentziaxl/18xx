# frozen_string_literal: true

require_relative '../../../step/tracker'

module Engine
  module Game
    module G18ESP
      module Tracker
        include Engine::Step::Tracker
        def potential_tiles(entity, hex)
          selected_tiles(entity, hex).uniq(&:name)
            .select { |t| @game.upgrades_to?(hex.tile, t) }
            .reject(&:blocks_lay)
        end

        def selected_tiles(entity, hex)
          colors = potential_tile_colors(entity, hex)
          @game.tiles.select do |tile|
            @game.tile_valid_for_phase?(tile, hex: hex,
                                              phase_color_cache: colors) && tile_valid_for_entity(entity, tile)
          end
        end

        def tile_valid_for_entity(entity, tile)
          @game.north_corp?(entity) ? tile.paths.any? { |p| p.track == :narrow } : tile.paths.any? { |p| p.track == :broad }
        end

        def ability_blocking_hex(_entity, hex)
          return unless @game.mine_hexes.any? { |h| h == hex.name }

          @mine_blocking ||= Engine::Ability::BlocksHexes.new(type: :blocks_hexes, owner_type: :player,
                                                              hexes: @game.mine_hexes)
        end

        def lay_tile_action(action)
          entity = action.entity
          super
          entity.goal_reached!(:destination) if !entity.destination_connected? && @game.check_for_destination_connection(entity)
        end
      end
    end
  end
end
