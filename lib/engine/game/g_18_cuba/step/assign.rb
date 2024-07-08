# frozen_string_literal: true

require_relative '../../../step/assign'

module Engine
  module Game
    module G18Cuba
      module Step
        class Assign < Engine::Step::Assign
          def process_assign(action)
            company = action.entity
            return super unless company.id == 'M2'

            target = action.target

            if assignable_corporations(company).include?(target) &&
              (ability = @game.abilities(company, :assign_corporation))

              train = @game.depot.upcoming.find { |t| t.name == '1w' }
              ability.use!
              train ? gain_1w(company, target, train) : log_no_1w(target)

            else
              raise GameError, "Could not assign #{company.name} to #{target.name}; no assignable corporations found"
            end

            return if !ability.count&.zero? || !ability.closed_when_used_up

            @game.company_closing_after_using_ability(company)
            company.close!
          end

          def gain_1w(company, target, train)
            @game.buy_train(target, train, :free)
            @log << "#{target.name} gains 1w from depot (#{company.name})"
          end

          def log_no_1w(target)
            @log << "no 1w available in depot. #{target.name} does not gain a train"
          end

          def assignable_corporations(company = nil)
            super.reject { |c| c.type == :minor }
          end
        end
      end
    end
  end
end
