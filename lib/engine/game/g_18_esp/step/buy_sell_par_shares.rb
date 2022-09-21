# frozen_string_literal: true

require_relative '../../../step/buy_sell_par_shares'

module Engine
  module Game
    module G18ESP
      module Step
        class BuySellParShares < Engine::Step::BuySellParShares
          def get_par_prices(entity, corp)
            @game.par_prices(corp).select { |p| p.price * 2 <= entity.cash }
          end

          def can_gain?(entity, bundle, exchange: false)
            # Can buy above the share limit if from the share pool
            return true if bundle.owner == @game.share_pool && @game.num_certs(entity) < @game.cert_limit

            super
          end
          
        end
      end
    end
  end
end
