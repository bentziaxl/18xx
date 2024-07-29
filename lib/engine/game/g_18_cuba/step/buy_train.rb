# frozen_string_literal: true

require_relative '../../../step/base'
require_relative '../../../step/buy_train'
require_relative 'skip_fc'

module Engine
  module Game
    module G18Cuba
      module Step
        include SkipFc
        class BuyTrain < Engine::Step::BuyTrain
          def buyable_trains(entity)
            # Cannot buy trains from corps in liquidation.
            track_type = entity.type == :minor ? :narrow : :broad
            trains = super.select { |t| t.track_type == track_type }

            if entity.type == :minor
              trains.reject! { |t| @game.machine?(t) } unless room_for_machines(entity)
              trains.select! { |t| @game.machine?(t) } unless room_for_regular_trains(entity)
            else
              trains.reject! { |t| @game.wagon?(t) } unless room_for_wagons(entity)
              trains.select! { |t| @game.wagon?(t) } unless room_for_regular_trains(entity)
            end
            trains
          end

          def room_for_wagons(entity)
            @game.num_wagons(entity) < @game.train_limit(entity)
          end

          def room_for_machines(entity)
            @game.num_machines(entity) < 3
          end

          def room_for_regular_trains(entity)
            @game.num_corp_trains(entity) < @game.train_limit(entity)
          end

          def room?(entity, _shell = nil)
            room_for_extras = entity.type == :minor ? room_for_machines(entity) : room_for_wagons(entity)
            room_for_extras || room_for_regular_trains(entity)
          end
        end
      end
    end
  end
end
