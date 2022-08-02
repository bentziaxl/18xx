# frozen_string_literal: true

require_relative '../../../step/track'
require_relative 'tracker'

module Engine
  module Game
    module G18ESP
      module Step
        class Track < Engine::Step::Track
          include Engine::Game::G18ESP::Tracker

          def process_pass(action)
            if action.entity.companies.find { |comp| comp.sym == 'MEA' }
              raise GameError, 'The MEA must be used in the same OR it was purchased'
            end

            super
          end
        end
      end
    end
  end
end
