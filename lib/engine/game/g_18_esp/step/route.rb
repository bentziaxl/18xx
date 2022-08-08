# frozen_string_literal: true

require_relative '../../../step/route'

module Engine
  module Game
    module G18ESP
      module Step
        class Route < Engine::Step::Route
          def setup
            puts(@round.mea_hex)
            super 
          end

          # def round_state
          #   # super.merge({
          #   #   routes: [],
          #   # })
          # end

        end
      end
    end
  end
end
