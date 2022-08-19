# frozen_string_literal: true

require_relative '../../../step/dividend'

module Engine
  module Game
    module G18ESP
      module Step
        class Dividend < Engine::Step::Dividend
          def process_dividend(action)
            subsidy = @game.routes_subsidy(routes)
            if subsidy.positive?
              @game.bank.spend(subsidy, action.entity)
              @log << "#{action.entity.name} retains a subsidy of #{@game.format_currency(subsidy)}"
            end
            super
            train = action.entity.trains.find { |t| t.name == 'F' }
            return unless train

            train.operated = false
            @game.depot.reclaim_train(train)
            # mea_tile = @round.mea_hex&.tile
            # mea_tile&.remove_temp_halt
            # puts(mea_tile&.code)
            # @round.mea_hex&.lay_downgrade(mea_tile)
          end
        end
      end
    end
  end
end
