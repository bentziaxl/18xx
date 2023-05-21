# frozen_string_literal: true

require_relative '../../../step/special_track'
require_relative 'lay_tile_check'

module Engine
  module Game
    module G18ESP
      module Step
        class SpecialTrack < Engine::Step::SpecialTrack
          include LayTileCheck

          def process_lay_tile(action)
            super
          end

          def available_hex(entity, hex)
            hex.tile.color == :white || hex.id == 'G18' ? super : nil
          end

          def close!(company, owner)
            owner.companies.delete(company)
            company.owner = nil
          end

          def lay_tile(action, extra_cost: 0, entity: nil, spender: nil)
            super
            corp = action.entity.owner
            corp.goal_reached!(:destination) if @game.check_for_destination_connection(corp)
          end

          def potential_tiles(entity, hex)
            tiles = super
            tiles.reject { |tile| tile.city_towns.empty? && tile.color != :yellow }
          end
        end
      end
    end
  end
end
