# frozen_string_literal: true

require_relative '../../../step/route'

module Engine
  module Game
    module G18ESP
      module Step
        class Route < Engine::Step::Route
          # def process_run_routes(action)
          #   super
          #   @game.discard_f_train(action) if action.entity.trains.any? { |train| train.name == 'F' }
          # end
        end
      end
    end
  end
end
