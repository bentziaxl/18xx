# frozen_string_literal: true

require_relative '../../../step/token'

module Engine
  module Game
    module G18ESP
      module Step
        class Token < Engine::Step::Token
          def place_token(entity, city, token)
            mount_pass_cost = @game.mountain_pass_token_cost(city.hex)
            if mount_pass_cost
              token.price = mount_pass_cost
              token.type = :neutral
            end
            super(entity, city, token)
          end
        end
      end
    end
  end
end
