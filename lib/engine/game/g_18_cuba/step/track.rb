# frozen_string_literal: true

require_relative '../../../step/tracker'
require_relative '../../../step/track'

module Engine
  module Game
    module G18Cuba
      module Step
        class Track < Engine::Step::Track
          def potential_tiles(entity, hex)
            tiles = super
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
        end
      end
    end
  end
end