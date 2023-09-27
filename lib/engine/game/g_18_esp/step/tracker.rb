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
                                              phase_color_cache: colors)
          end
        end

        def lay_tile_action(action)
          hex = action.hex
          old_tile = hex.tile
          tile_frame = old_tile.frame
          super

          if @game.mine_hex?(action.hex) && old_tile.color == :white
            @round.num_laid_track -= 1
            @round.mine_tile_laid = true
          end

          old_tile.reframe!(nil)
          hex.tile.reframe!(tile_frame.color, tile_frame.color2) if tile_frame
          old_tile&.icons = []

          tokens = hex.tile.cities.first.tokens if hex.id == 'F24'
          if hex.id == 'F24' && tokens.find { |t| t&.corporation&.name == 'MZ' } && tokens.find do |t|
               t&.corporation&.name == 'MZA'
             end && (action.tile.color == :brown || action.tile.color == :gray)
            mz_token = tokens.find { |t| t&.corporation&.name == 'MZ' }
            hex.tile.cities.first.delete_token!(mz_token)
            hex.tile.cities.first.exchange_token(mz_token, extra_slot: true)
          end
          # clear graphs
          @game.graph.clear

          action.entity.goal_reached!(:destination) if @game.check_for_destination_connection(action.entity)
        end

        def extra_cost(tile, tile_lay, hex)
          @game.mine_hex?(hex) ? 0 : super
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
          get_tile_lay(entity)
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
