# frozen_string_literal: true

require_relative '../../../step/dividend'

module Engine
  module Game
    module G18Cuba
      module Step
        class Dividend < Engine::Step::Dividend
          ACTIONS = ['dividend'].freeze

          def actions(entity)
            return super unless entity == @game.fc

            ACTIONS
          end

          def auto_actions(entity)
            return super unless entity == @game.fc

            [Action::Dividend.new(entity, kind: 'payout')]
          end

          def total_revenue
            current_entity == @game.fc ? calc_fc_revenue : super
          end

          def calc_fc_revenue
            fc = @game.fc
            distance = fc.trains.first.distance
            city_revenue = 0 # fc.tokens.map {|token| token.city.revenue[phase_color] || 0 }.sort.take(distance).sum
            fc.cash + city_revenue
          end

          def phase_color
            @game.phase.current[:tiles].last
          end
        end
      end
    end
  end
end
