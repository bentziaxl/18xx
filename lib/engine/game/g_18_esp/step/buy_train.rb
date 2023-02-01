# frozen_string_literal: true

require_relative '../../../step/base'
require_relative '../../../step/buy_train'

module Engine
  module Game
    module G18ESP
      module Step
        class BuyTrain < Engine::Step::BuyTrain
          def buyable_trains(entity)
            # Cannot buy F train
            trains = super
            trains.reject! { |t| t.name == 'F' }
            trains.reject! { |t| t.track_type == :narrow } if entity.type == :minor
            trains
          end

          def buyable_train_variants(train, entity)
            trains = super
            type = @game.north_corp?(entity) ? :broad : :narrow

            trains.reject! { |v| type?(v[:name], type) } if owns_type?(entity, type)
            trains.reject! { |v| type?(v[:name], :narrow) } if entity.type == :minor
            trains
          end

          def type?(name, type)
            (name.include?('+') && type == :narrow) || (!name.include?('+') && type == :broad)
          end

          def owns_type?(entity, type)
            entity.trains&.any? { |t| t.track_type == type }
          end

          def try_take_player_loan(entity, cost)
            return unless cost.positive?
            return unless cost > entity.cash

            raise GameError, "#{entity.name} already sold shares this round. Can not take loans" unless @corporations_sold.empty?

            difference = cost - entity.cash
            @game.take_player_loan(entity, difference)
            @log << "#{entity.name} takes a loan of #{@game.format_currency(difference)}"
          end
        end
      end
    end
  end
end
