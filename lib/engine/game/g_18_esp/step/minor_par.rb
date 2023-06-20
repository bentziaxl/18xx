# frozen_string_literal: true

require_relative '../../../step/buy_sell_par_shares'

module Engine
  module Game
    module G18ESP
      module Step
        class MinorPar < Engine::Step::BuySellParShares
          def visible_corporations
            @game.corporations.select { |c| c.type == :minor && !c.ipoed }
          end

          def all_passed!
            # Everyone has passed so we need to run a fake OR.
            @game.payout_companies
            entities.each(&:unpass!)
          end

          def process_pass(action)
            super
            all_passed! if entities.all?(&:passed?)
          end
        end
      end
    end
  end
end
