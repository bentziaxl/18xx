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

            if action.entity.name == 'MZ'
              # remove reservation in the chosen slot
              action.city.remove_all_reservations!
            end
            place_token(
              token.corporation,
              action.city,
              token,
              connected: false,
              extra_action: true
            )
            @round.pending_tokens.shift
          end

          def help
            'Select which of the three Madrid locations MZ should place its home token' if current_entity.name == 'MZ'
          end
        end
      end
    end
  end
end