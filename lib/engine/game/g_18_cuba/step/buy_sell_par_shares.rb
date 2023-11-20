# frozen_string_literal: true

require_relative '../../../step/buy_sell_par_shares'

module Engine
  module Game
    module G18Cuba
      module Step
        class BuySellParShares < Engine::Step::BuySellParShares
          def process_buy_shares(action)
            super
            corp = action.bundle.corporation
            return if corp.type

            reclaim_token(corp, 2) if corp.treasury_shares.sum(&:percent) == 30
            reclaim_token(corp, 3) if corp.treasury_shares.sum(&:percent).zero?
          end

          def reclaim_token(corp, token_num)
            token = corp.tokens[token_num]
            return unless token

            token.used = false if token.used == true && !token.city
            @game.log << "#{corp.name} recieves an addditional token"
          end

          def process_par(action)
            raise GameError, 'Cannot par on behalf of other entities' if action.purchase_for

            share_price = action.share_price
            corporation = action.corporation
            entity = action.entity

            raise GameError, "#{corporation.name} cannot be parred" unless @game.can_par?(corporation, entity)

            if entity.companies.intersect?(@game.concessions) && corporation.type == :minor
              @game.stock_market.set_par(corporation, share_price)
              share = corporation.ipo_shares.take(2)
              bundle = ShareBundle.new(share)
              exchange_price = (share_price.price * bundle.num_shares) - @game.class::CONCESSION_DISCOUNT
              @round.players_bought[entity][corporation] += share.sum(&:percent)
              concession = entity.companies.find { |c| @game.concession?(c) }
              buy_shares(entity, bundle, exchange: concession, exchange_price: exchange_price)
              # Close the concession company
              concession.close!
              @game.after_par(corporation)
              @game.bank.spend(@game.class::CONCESSION_DISCOUNT, corporation)
              track_action(action, action.corporation)
            else
              super
            end
          end

          def can_buy?(entity, bundle)
            super &&
            !(bundle.owner.corporation? && bundle.corporation.type == :minor && bundle.corporation.floated?)
          end
        end
      end
    end
  end
end
