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
          end
        end
      end
    end
  end
end
