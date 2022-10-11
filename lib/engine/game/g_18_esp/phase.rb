# frozen_string_literal: true

require_relative '../../phase'

module Engine
  module Game
    module G18ESP
      class Phase < Engine::Phase
        def buying_train!(entity, train)
          return if train.name == '5+5' && train.sym == '8'

          super
        end
      end
    end
  end
end
