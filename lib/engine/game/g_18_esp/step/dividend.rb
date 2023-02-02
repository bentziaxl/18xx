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

          def handle_mine_halt(train)
            train.operated = false
            @game.depot.reclaim_train(train)
            mea_tile = @round.mea_hex&.tile
            return unless mea_tile.only_paths_originally?

            mea_tile&.remove_temp_halt
            @round.mea_hex&.lay_downgrade(mea_tile)
          end

          def half_pay_f_train(entity)
            amount = @game.f_train_revenue(routes) / 2
            return unless amount.positive?

            @log << "#{entity.name} receives #{@game.format_currency(amount)} for Freight Train route"
            payout_corporation(amount, entity)
            @log << "#{entity.owner.name} receives #{@game.format_currency(amount)} for Freight Train route"
            @game.bank.spend(amount, entity.owner)
          end

          def payout_per_share(entity, revenue)
            revenue * 1.0 / entity.total_shares
          end
        end
      end
    end
  end
end
