# frozen_string_literal: true

require_relative '../../../step/tracker'

module Engine
  module Game
    module G18ESP
      module Tracker
        include Engine::Step::Tracker
        def potential_tiles(entity, hex)
          tiles = selected_tiles(entity, hex).uniq(&:name)
            .select { |t| @game.upgrades_to?(hex.tile, t) }
            .reject(&:blocks_lay)

          tiles = tiles.reject { |tile| tile.city_towns.empty? && tile.color != :yellow } if @game.north_corp?(entity)
          tiles
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
          super
          entity.goal_reached!(:destination) if @game.check_for_destination_connection(action.entity)
        end

        def mountain_pass_exit(hex, tile)
          return false unless @game.mountain_pass_access?(hex)

          new_exits = tile.exits - hex.tile.exits

          new_exits.find do |exit|
            neighbor = hex.neighbors[exit]
            ntile = neighbor&.tile
            next false unless ntile
            next false unless @game.mountain_pass?(ntile.hex)

            ntile.exits.any? { |e| e == Hex.invert(exit) }
          end
        end

        def legal_tile_rotation?(entity, hex, tile)
          super # && !opening_mountain_pass?(entity, hex, tile)
        end
      end
    end
  end
end
