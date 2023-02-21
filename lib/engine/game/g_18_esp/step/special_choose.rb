# frozen_string_literal: true

require_relative '../../../step/special_choose'
require_relative '../../../step/tokener'

module Engine
  module Game
    module G18ESP
      module Step
        class SpecialChoose < Engine::Step::SpecialChoose
          include Engine::Step::Tokener
          def actions(entity)
            return [] unless opening_mountain_pass?(entity)

            super
          end

          def opening_mountain_pass?(entity)
            corp = entity.owner
            return false unless corp.corporation?

            !@game.opening_new_mountain_pass(corp).empty?
          end

          def choices_ability
            @game.opening_new_mountain_pass(current_entity, true)
          end

          def process_choose_ability(action)
            corp = action.entity.owner
            @game.open_mountain_pass(corp, action.choice, true)
            place_token_in_pass(corp, action.choice)
            @game.graph_for_entity(corp).clear
            @log << "#{action.entity.name} closes"
            action.entity.close!
          end

          def place_token_in_pass(corp, mountain_pass)
            hex = @game.hex_by_id(mountain_pass)
            tile = hex.tile
            city = tile.cities.first
            @round.tokened_mountain_pass = city
            token = Token.new(corp, price: 0)
            corp.tokens << token
            place_token(corp, city, token, extra_action: true)
          end
        end
      end
    end
  end
end
