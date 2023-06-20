# frozen_string_literal: true

require_relative '../../../round/stock'

module Engine
  module Game
    module G18ESP
      module Round
        class MinorStock < Engine::Round::Stock
          def finished?
            @game.finished || @active_step&.visible_corporations&.empty?
          end
        end
      end
    end
  end
end
