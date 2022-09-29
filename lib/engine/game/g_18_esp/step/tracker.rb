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
          tiles = tiles.reject { |tile| tile.paths.any? { |path| path.track == :narrow } } unless @game.north_hex?(hex)
          if @game.north_hex?(hex) && @game.north_corp?(entity)
            tiles = tiles.reject do |tile|
              tile.paths.any? do |path|
                path.track == :broad
              end
            end
          end
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
          narrow_only?(entity) ? tile.paths.any? { |p| p.track == :narrow } : true
        end

        def narrow_only?(entity)
          @game.north_corp?(entity) && !entity.interchange?
        end

        def ability_blocking_hex(_entity, hex)
          return unless @game.mine_hexes.any? { |h| h == hex.name }

          @mine_blocking ||= Engine::Ability::BlocksHexes.new(type: :blocks_hexes, owner_type: :player,
                                                              hexes: @game.mine_hexes)
        end

        def lay_tile_action(action)
          super
          action.entity.goal_reached!(:destination) if @game.check_for_destination_connection(action.entity)
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

        def can_open_mountain_pass?(entity)
          entity.type != :minor && @game.phase.status.include?('can_build_mountain_pass')
        end

        def legal_tile_rotation?(entity, hex, tile)
          can_open_mountain_pass?(entity) ? super : super && !mountain_pass_exit(hex, tile)
        end

        # minors cant upgrade madrid or barca
        def upgradeable_tiles(entity, hex)
          return super if entity.type != :minor || !%w[G24 N21].include?(hex.id)

          []
        end

        def can_buy_tile_laying_company?(entity)
          entity.companies.none? { |comp| comp.sym == 'MEA' } && !@round.mea_hex
        end
      end
    end
  end
end
