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
          @round.extra_mine_lay = false
          @round.mine_tile_laid = false
        end

        def selected_tiles(entity, hex)
          colors = potential_tile_colors(entity, hex)
          @game.tiles.select do |tile|
            @game.tile_valid_for_phase?(tile, hex: hex,
                                              phase_color_cache: colors) && tile_valid_for_entity(entity, tile, hex)
          end
        end

        def lay_tile_action(action)
          if mountain_pass_track_restriction(action.hex, action.tile, action.rotation)
            raise GameError,
                  'Tiles connecting into the 4 mountain passes can not be of the same track type'
          end
          hex = action.hex
          old_tile = hex.tile
          tile_frame = old_tile.frame
          super

          if @game.mine_hex?(action.hex)
            @round.num_laid_track -= 1
            @round.mine_tile_laid = true
          end

          old_tile.reframe!(nil)
          hex.tile.reframe!(tile_frame.color, tile_frame.color2) if tile_frame
          old_tile&.icons = []

          # clear graphs
          @game.graph.clear
          @game.broad_graph.clear

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
          return super if entity.type != :minor || !%w[F24 M21].include?(hex.id)

          []
        end

        def round_state
          super.merge(
            {
              extra_mine_lay: false,
              mine_tile_laid: false,
            }
          )
        end

        def tracker_available_hex(entity, hex)
          return super && @game.mine_hex?(hex) if @round.extra_mine_lay

          @round.mine_tile_laid ? super && !@game.mine_hex?(hex) : super
        end

        def get_tile_lay(entity)
          action = super
          # if action is nil, and mine wasn't laid, grant a lay action buy only for mine
          if action.nil? && !@round.mine_tile_laid
            @round.extra_mine_lay = true
            return { lay: true, upgrade: false, cost: 0 }
          end
          action
        end
      end
    end
  end
end
