# frozen_string_literal: true

require_relative '../../../step/buy_sell_par_shares'

module Engine
  module Game
    module G18ESP
      module Step
        class BuySellParShares < Engine::Step::BuySellParShares
          def actions(entity)
            actions = super
            actions << 'payoff_player_debt' if @game.player_debt(entity).positive? && entity.cash.positive?

            actions
          end

          def get_par_prices(entity, corp)
            @game.par_prices(corp).select { |p| p.price * 2 <= entity.cash }
          end

          def can_gain?(entity, bundle, exchange: false)
            # Can buy above the share limit if from the share pool
            return true if bundle.owner == @game.share_pool && @game.num_certs(entity) < @game.cert_limit

            super
          end

          def process_payoff_player_debt(action)
            player = action.entity
            @game.payoff_player_loan(player)
            track_action(action, player)
            log_pass(player)
            pass!
          end

          def can_buy_any?(entity)
            @game.player_debt(entity).zero? && super
          end

          def can_ipo_any?(entity)
            @game.player_debt(entity).zero? && super
          end
        end
      end
    end
  end
end
