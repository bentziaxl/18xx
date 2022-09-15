# frozen_string_literal: true

require_relative '../../../step/token'

module Engine
  module Game
    module G18ESP
      module Step
        class Token < Engine::Step::Token
          def place_token(entity, city, token)
            token.type = :neutral if @game.mountain_pass_token_hex?(city.hex)
            super(entity, city, token)
          end
        end
      end
    end
  end
end
