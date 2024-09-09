# frozen_string_literal: true

require_relative '../../../step/route'
require_relative 'skip_fc'

module Engine
  module Game
    module G18Cuba
      module Step
        class Route < Engine::Step::Route
          def process_run_routes(action)
            super
            return unless action.entity.type == :minor

            revenue = @game.routes_revenue(@round.routes)

            gain_sugar_cubes(action.entity, revenue) if revenue.positive?
          end

          def gain_sugar_cubes(corp, revenue)
            sugar_cubes = case revenue
                          when 0..20 then 0
                          when 30..70 then 1
                          when 80..150 then 2
                          else 3
                          end

            @game.log << "#{corp.name} gains #{sugar_cubes} sugar cube(s)"
            @game.sugar_cubes[corp] += sugar_cubes
          end
        end
      end
    end
  end
end
