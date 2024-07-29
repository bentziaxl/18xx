# frozen_string_literal: true

require_relative '../../../step/assign'

module Engine
  module Game
    module G18Cuba
      module Step
        class Assign < Engine::Step::Assign
          def process_assign(action)
            company = action.entity
            return super unless assignable_company(company)

            target = action.target

            if assignable_corporations(company).include?(target) &&
              (ability = @game.abilities(company, :assign_corporation))

              company.id == 'M2' ? assign_1w(ability, company, target) : assign_1m(ability, company, target)

            else
              raise GameError, "Could not assign #{company.name} to #{target.name}; no assignable corporations found"
            end

            return if !ability.count&.zero? || !ability.closed_when_used_up

            @game.company_closing_after_using_ability(company)
            company.close!
          end

          def assign_1m(ability, company, target)
            train = @game.depot.upcoming.find { |t| @game.machine?(t) }
            ability.use!
            train ? gain_train(company, target, train) : log_no_train(target)
          end

          def assign_1w(ability, company, target)
            train = @game.depot.upcoming.find { |t| t.name == '1w' }
            ability.use!
            train ? gain_train(company, target, train) : log_no_train(target)
          end

          def gain_train(company, target, train)
            @game.buy_train(target, train, :free)
            @log << "#{target.name} gains #{train.name} from depot (#{company.name})"
          end

          def log_no_train(target)
            train_name = target.type == :minor ? 'machines' : '1w'
            @log << "no #{train_name} available in depot. #{target.name} does not gain a train"
          end

          def assignable_company(entity)
            entity.id == 'M2' || entity.id == 'M3'
          end

          def assignable_corporations(company = nil)
            super.reject { |c| c.type == :minor }
          end
        end
      end
    end
  end
end
