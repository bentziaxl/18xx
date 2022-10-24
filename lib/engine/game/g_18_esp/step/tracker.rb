# frozen_string_literal: true

require_relative '../../../step/tracker'
require_relative 'lay_tile_check'

module Engine
  module Game
    module G18ESP
      module Tracker
        include Engine::Step::Tracker
        include LayTileCheck

        def setup
          super
          @round.north_corp_southern_hex = false
        end

        def selected_tiles(entity, hex)
          colors = potential_tile_colors(entity, hex)
          @game.tiles.select do |tile|
            @game.tile_valid_for_phase?(tile, hex: hex,
                                              phase_color_cache: colors) && tile_valid_for_entity(entity, tile)
          end
        end

        def ability_blocking_hex(_entity, hex)
          return if @game.mine_hexes.none? { |h| h == hex.name } || hex.tile.color != :white

          @mine_blocking ||= Engine::Ability::BlocksHexes.new(type: :blocks_hexes, owner_type: :player,
                                                              hexes: @game.mine_hexes)
        end

        def lay_tile_action(action)
          if mountain_pass_track_restriction(action.hex, action.tile, action.rotation)
            raise GameError,
                  'Tiles connecting into the 4 mountain passes can not be of the same track type'
          end

          super
          action.entity.goal_reached!(:destination) if @game.check_for_destination_connection(action.entity)
        end

        def mountain_pass_track_restriction(hex, tile, rotation)
          return false unless @game.mountain_pass_access?(hex)
          return false unless tile.color == :yellow

          tile_track_type = get_mountain_pass_access_path_track(hex, tile: tile, rotation: rotation)

          track_types = @game.class::MOUNTAIN_PASS_ACCESS_HEX.map do |h|
            get_mountain_pass_access_path_track(@game.hex_by_id(h))
          end.compact
          uniq_types = track_types.uniq
          last_tile_different = uniq_types.length == 1 && track_types.length == 3
          return false unless last_tile_different

          return false unless uniq_types.first == tile_track_type

          true
        end

        def get_mountain_pass_access_path_track(hex, tile: nil, rotation: nil)
          #  mountain_pass_exit(hex, tile)
          tile ||= hex.tile
          tile.rotate!(rotation) if rotation
          mount_path = tile.paths.find do |path|
            path.exits.find do |exit|
              neighbor = hex.neighbors[exit]
              ntile = neighbor&.tile
              next false unless ntile
              next false unless @game.mountain_pass?(ntile.hex)

              ntile.exits.any? { |e| e == Hex.invert(exit) }
            end
          end
          mount_path&.track
        end

        # minors cant upgrade madrid or barca
        def upgradeable_tiles(entity, hex)
          return super if entity.type != :minor || !%w[G24 N21].include?(hex.id)

          []
        end

        def can_buy_tile_laying_company?(entity, time:)
          entity.companies.none? { |comp| comp.sym == 'MEA' } && !@round.mea_hex
        end

        def round_state
          super.merge(
            {
              north_corp_southern_hex: false,
            }
          )
        end

        def tracker_available_hex(entity, hex)
          @round.north_corp_southern_hex ? super && !@game.north_hex?(hex) : super
        end

        def get_tile_lay(entity)
          action = super
          return action unless @game.north_corp?(entity)

          if @round.num_laid_track == 1 && !@game.north_hex?(@round.laid_hexes.first)
            @round.north_corp_southern_hex = true
            action = @game.tile_lays_north_corp_south.dup

            action[:lay] = !@round.upgraded_track if action[:lay] == :not_if_upgraded
            action[:upgrade] = !@round.upgraded_track if action[:upgrade] == :not_if_upgraded
            action[:cost] = action[:cost] || 0
            action[:upgrade_cost] = action[:upgrade_cost] || action[:cost]
            action[:cannot_reuse_same_hex] = action[:cannot_reuse_same_hex] || false
          end
          action
        end
      end
    end
  end
end
