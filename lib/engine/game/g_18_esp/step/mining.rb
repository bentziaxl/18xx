# frozen_string_literal: true

require_relative '../../../step/buy_company'

module Engine
  module Game
    module G18ESP
      module Step
        class Mining < Engine::Step::Base
          ACTIONS = %w[special_buy pass].freeze
          def actions(_entity)
            ACTIONS
          end

          def description
            'Buy MEA (Mining Exploitation Authorization)'
          end

          def pass_description
            'Skip (MEA)'
          end

          def buyable_items(_entity)
            [Item.new(description: 'MEA', cost: 30)]
          end

          def assignable_corporations(_company = nil)
            @game.corporations
          end

          def can_special_buy?(_entity)
            true
          end

          def process_special_buy(action)
            buy_company(action)
          end

          def buy_company(action)
            # was ability used?
            @game.mea.reset_ability_count_this_or!

            entity = action.entity
            entity.spend(@game.mea.value, @game.bank)
            @game.mea.owner = entity
            entity.companies << @game.mea
            pass!
          end
        end
      end
    end
  end
end
