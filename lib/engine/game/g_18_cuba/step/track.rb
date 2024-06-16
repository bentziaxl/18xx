# frozen_string_literal: true

require_relative '../../../step/tracker'
require_relative '../../../step/track'
require_relative 'skip_fc'

module Engine
  module Game
    module G18Cuba
      module Step
        class Track < Engine::Step::Track
          include SkipFc
          def potential_tiles(entity, hex)
            tiles = super
            tiles.reject! { |t| t.cities.sum(&:normal_slots) == 1 } if entity.type == :minor

            track_to_reject = entity.type == :minor ? :broad : :narrow
            tiles.reject! do |tile|
              track_types = tile.paths.map(&:track).uniq
              if entity.type == :minor
                if hex == entity.tokens.first.hex
                  track_types.size == 1 && track_types.first == track_to_reject
                else
                  tile.cities.size > 1 || track_types.first == track_to_reject
                end
              else
                track_types.include?(track_to_reject)
              end
            end

            tiles
          end

          def tracker_available_hex(entity, hex)
            return nil if entity.type == :minor && !hex.tile.cities.empty? && hex.id != entity.coordinates

            connected = hex_neighbors(entity, hex)
            return nil unless connected

            tile_lay = get_tile_lay(entity)
            return nil unless tile_lay

            color = hex.tile.color
            return nil if color == :white && !tile_lay[:lay]
            return nil if color != :white && !tile_lay[:upgrade]
            return nil if color != :white && tile_lay[:cannot_reuse_same_hex] && @round.laid_hexes.include?(hex)
            return nil if ability_blocking_hex(entity, hex)

            connected
          end
        end
      end
    end
  end
end
