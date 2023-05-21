# frozen_string_literal: true

require_relative '../../../step/dividend'

module Engine
  module Game
    module G18ESP
      module Step
        class Dividend < Engine::Step::Dividend
          ACTIONS = %w[dividend].freeze

          def actions(entity)
            return [] if entity.company? || @game.routes_revenue(routes).zero?

            ACTIONS
          end

          def share_price_change(entity, revenue = 0)
            price = entity.share_price.price
            return { share_direction: :left, share_times: 1 } unless revenue.positive?

            times = 1 if revenue.positive?
            times = 2 if revenue >= price * 2
            if times.positive?
              { share_direction: :right, share_times: times }
            else
              {}
            end
          end

          def movement_str(times, dir)
            "#{times} #{dir}"
          end

          def process_dividend(action)
            subsidy = @game.routes_subsidy(routes)
            if subsidy.positive?
              @game.bank.spend(subsidy, action.entity)
              @log << "#{action.entity.name} retains a subsidy of #{@game.format_currency(subsidy)}"
            end
            super
          end

          def payout_per_share(entity, revenue)
            revenue * 1.0 / entity.total_shares
          end
        end
      end
    end
  end
end
