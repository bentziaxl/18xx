# frozen_string_literal: true

require_relative '../../../step/route'

module Engine
  module Game
    module G18ESP
      module Step
        class Route < Engine::Step::Route
          def process_run_routes(action)
            action.entity.goal_reached!(:offboard) if @game.check_offboard_goal(action.entity, action.routes)
            action.entity.goal_reached!('southern map') if @game.check_southern_map_goal(action.entity, action.routes)
            super
          end
        end
      end
    end
  end
end
