# frozen_string_literal: true

require_relative '../../../step/home_token'

module Engine
  module Game
    module G18Cuba
      module Step
        class HomeToken < Engine::Step::HomeToken
          def process_place_token(action)
            # the action is faked and doesn't represent the actual token laid
            hex = action.city.hex
            raise GameError, "Cannot place token on #{hex.name} as the hex is not available" unless available_hex(action.entity,
                                                                                                                  hex)

            cheater = action.entity.type == :minor
            @log << "#{action.entity.name} places a token on #{hex.name}"
            action.city.place_token(action.entity, token, cheater: cheater)

            @round.pending_tokens.shift
          end
        end
      end
    end
  end
end
