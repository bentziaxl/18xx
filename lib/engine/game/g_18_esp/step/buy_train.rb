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
            trains.reject! { |t| t.track_type == :broad && t.owner != @depot } unless room_for_type?(entity, :broad)
            trains.reject! { |t| t.track_type == :narrow && t.owner != @depot } unless room_for_type?(entity, :narrow)
            trains
          end

          def buyable_train_variants(train, entity)
            trains = super

            trains.reject! { |v| type?(v[:name], :narrow) } if entity.type == :minor
            trains.reject! { |v| type?(v[:name], :broad) } unless room_for_type?(entity, :broad)
            trains.reject! { |v| type?(v[:name], :narrow) } unless room_for_type?(entity, :narrow)
            trains
          end

          def type?(name, type)
            (name.include?('+') && type == :narrow) || (!name.include?('+') && type == :broad)
          end

          def try_take_player_loan(entity, cost)
            return unless cost.positive?
            return unless cost > entity.cash

            raise GameError, "#{entity.name} already sold shares this round. Can not take loans" unless @corporations_sold.empty?

            difference = cost - entity.cash
            @game.take_player_loan(entity, difference)
            @log << "#{entity.name} takes a loan of #{@game.format_currency(difference)}"
          end

          def room?(entity, _shell = nil)
            return room_for_type?(entity, :narrow) || room_for_type?(entity, :broad) if @game.phase.available?('4')

            super
          end

          def room_for_type?(entity, type)
            return room?(entity) unless @game.phase.available?('4')

            trains = entity.trains.group_by(&:track_type)
            (trains[type]&.size || 0) < @game.train_limit_by_type(entity, type)
          end
        end
      end
    end
  end
end
