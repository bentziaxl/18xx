# frozen_string_literal: true

require_relative '../../../step/base'

module Engine
  module Game
    module G18ESP
      module Step
        class Choose < Engine::Step::Base
          ACTIONS = %w[choose pass].freeze

          def actions(entity)
            return [] unless entity == current_entity
            return [] unless can_buy_carriage?(entity)

            ACTIONS
          end

          def can_buy_carriage?(entity)
            # have p4 ability left, have 30 bucks, doesn't own carriage
            !@game.luxury_ability(entity) &&
            @game.luxury_carriages.size.positive? &&
            entity.cash > @game.carriage_cost
          end

          def choice_name
            'Buy Luxury Carriage'
          end

          def choices
            @game.luxury_carriages.uniq.to_h { |owner| [owner.id, "Buy luxury carriage from #{owner.name}"] }
          end

          def description
            'Luxury Carriage'
          end

          def process_choose(action)
            entity = @game.player_by_id(action.choice) || @game.corporation_by_id(action.choice)
            a = @game.luxury_carriages.find_index(entity)
            @game.luxury_carriages.delete_at(a)
            luxury_ability = Ability::Base.new(
              type: 'base',
              owner_type: 'corporation',
              description: 'Luxury Carriage',
              desc_detail: 'Private allows to attach Luxury crriage to regular trains '\
                           'extending their distance by one town.',
              when: 'owning_corp_or_turn'
            )
            action.entity.add_ability(luxury_ability)
            action.entity.spend(@game.carriage_cost, entity)
            @log << "#{action.entity.name} buys a luxury carriage from #{entity.name} \
                    for #{@game.format_currency(@game.carriage_cost)} \
                    There are #{@game.luxury_carriages.size} luxury carriages left"
          end

          def skip!
            pass!
          end
        end
      end
    end
  end
end
