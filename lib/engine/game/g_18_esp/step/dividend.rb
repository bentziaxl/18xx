# frozen_string_literal: true

require_relative '../../../step/dividend'

module Engine
  module Game
    module G18ESP
      module Step
        class Dividend < Engine::Step::Dividend
          ACTIONS = %w[dividend].freeze

          def actions(entity)
            return [] if entity.company? || adjusted_revenue(routes).zero?

            ACTIONS
          end

          def adjusted_revenue(routes)
            @game.routes_revenue(routes) - f_train_revenue
          end

          def process_dividend(action)
            subsidy = @game.routes_subsidy(routes)
            if subsidy.positive?
              @game.bank.spend(subsidy, action.entity)
              @log << "#{action.entity.name} retains a subsidy of #{@game.format_currency(subsidy)}"
            end

            half_pay_f_train(action.entity)

            super

            train = action.entity.trains.find { |t| t.name == 'F' }
            return unless train

            handle_mine_halt(train)
          end

          def dividend_options(entity)
            revenue = @game.routes_revenue(routes)
            adjusted_revenue = revenue - f_train_revenue

            dividend_types.to_h do |type|
              payout = send(type, entity, adjusted_revenue)
              payout[:divs_to_corporation] = corporation_dividends(entity, payout[:per_share])
              [type, payout.merge(share_price_change(entity, adjusted_revenue - payout[:corporation]))]
            end
          end

          def handle_mine_halt(train)
            train.operated = false
            @game.depot.reclaim_train(train)
            mea_tile = @round.mea_hex&.tile
            mea_tile&.remove_temp_halt
            @round.mea_hex&.lay_downgrade(mea_tile)
          end

          def half_pay_f_train(entity)
            amount = f_train_revenue / 2
            return unless amount.positive?

            payout_corporation(amount, entity)
            @log << "#{entity.owner.name} receives #{@game.format_currency(amount)} for Freight Train route"
            @game.bank.spend(amount, entity.owner)
          end

          def f_train_revenue
            routes.find { |r| r.train.name == 'F' }&.revenue || 0
          end
        end
      end
    end
  end
end
