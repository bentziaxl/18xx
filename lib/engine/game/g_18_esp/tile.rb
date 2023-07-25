# frozen_string_literal: true

require_relative '../../tile'

module Engine
  module Game
    module G18ESP
      class Tile < Engine::Tile
        def paths_are_subset_of?(other_paths)
          return super unless towns.any?(&:halt?)

          other_exits = other_paths.flat_map(&:exits).uniq
          ALL_EDGES.any? { |ticks| (exits - other_exits.map { |e| (e + ticks) % 6 }).empty? }
        end
      end
    end
  end
end
