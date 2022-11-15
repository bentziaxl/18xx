# frozen_string_literal: true

require_relative '../../../step/buy_company'

module Engine
  module Game
    module G18ESP
      module Step
        class Mining < Engine::Step::Base
          ACTIONS = %w[special_buy].freeze

          def actions(entity)
            return [] if entity != current_entity || @game.mea&.owner == entity

            track_step = @round.steps.find { |step| step.is_a?(Track) }
            return [] if track_step.passed?

            ACTIONS
          end

          def description
            'Buy MEA (Mining Exploitation Authorization)'
          end

          def blocks?
            false
          end

          def pass_description
            'Skip (MEA)'
          end

          def buyable_items(entity)
            cost = mea_ability?(entity) ? 0 : 30
            [Item.new(description: 'MEA', cost: cost)]
          end

          def mea_ability?(entity)
            @mea_ability ||= entity.all_abilities.find { |ability| ability&.description&.start_with?('MEA') }
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
            cost = mea_ability?(entity) ? 0 : 30
            entity.spend(@game.mea.value, @game.bank) if cost.positive?
            entity.remove_ability(mea_ability?(entity)) if mea_ability?(entity)
            @game.mea.owner = entity
            entity.companies << @game.mea
            pass!
          end
        end
      end
    end
  end
end
