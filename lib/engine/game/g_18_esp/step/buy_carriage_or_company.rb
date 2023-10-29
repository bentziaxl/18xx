# frozen_string_literal: true

require_relative '../../../step/base'

module Engine
  module Game
    module G18ESP
      module Step
        class BuyCarriageOrCompany < Engine::Step::BuyCompany
          def actions(entity)
            return [] if !entity.corporation? || entity != current_entity

            actions = []
            actions << 'buy_company' if can_buy_company?(entity)
            actions << 'special_buy' if can_buy_carriage?(entity)
            actions << 'pass' if blocks?
            actions
          end

          def description
            'Buy Tender or Company'
          end

          def blocks?
            @opts[:blocks] && (can_buy_carriage?(current_entity) || can_buy_company?(current_entity))
          end

          def can_buy_carriage?(entity)
            # have p4 ability left, have 30 bucks, doesn't own carriage
            !@game.luxury_ability(entity) &&
            @game.luxury_carriages.size.positive? &&
            entity.cash >= @game.carriage_cost
          end

          def buyable_items(_entity)
            @game.luxury_carriages.uniq.map do |owner|
              Item.new(description: "tender from #{owner.name}", cost: @game.carriage_cost, owner: owner.id)
            end
          end

          def short_description
            'Buy Tender or Company'
          end

          def blocks?
            @opts[:blocks] && (can_buy_carriage?(current_entity) || can_buy_company?(current_entity))
          end

          def process_special_buy(action)
            item = action.item
            entity = @game.player_by_id(item.owner) || @game.corporation_by_id(item.owner)
            a = @game.luxury_carriages.find_index(entity)
            @game.luxury_carriages.delete_at(a)
            luxury_ability = Ability::Base.new(
              type: 'base',
              owner_type: 'corporation',
              description: 'Tender',
              desc_detail: 'Private allows to attach Tender to regular trains '\
                           'extending their distance by one town.',
              when: 'owning_corp_or_turn'
            )
            action.entity.add_ability(luxury_ability)
            action.entity.spend(@game.carriage_cost, entity)
            @log << "#{action.entity.name} buys a tender from #{entity.name} \
                    for #{@game.format_currency(item.cost)}. \
                    There are #{@game.luxury_carriages.size} tenders left"
          end
        end
      end
    end
  end
end
