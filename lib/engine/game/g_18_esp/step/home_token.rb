# frozen_string_literal: true

require_relative '../../../step/home_token'

module Engine
  module Game
    module G18ESP
      module Step
        class HomeToken < Engine::Step::HomeToken
          def process_place_token(action)
            hex = action.city.hex
            raise GameError, "Cannot place token on #{hex.name} as the hex is not available" unless available_hex(action.entity,
                                                                                                                  hex)

            check_tokenable = true
            cheater = nil
            if action.entity.name == 'MZ'
              check_tokenable = false
              cheater = 0
            end
            place_token(
              token.corporation,
              action.city,
              token,
              connected: false,
              extra_action: true,
              check_tokenable: check_tokenable,
              cheater: cheater
            )
            @round.pending_tokens.shift
          end
        end
      end
    end
  end
end
