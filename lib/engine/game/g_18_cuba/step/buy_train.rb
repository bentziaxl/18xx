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
            trains.reject! { |t| @game.extra_train?(t) } unless room_for_extra_trains(entity)
            trains.select! { |t| game.extra_train(t) } unless room_for_regular_trains(entity)
            trains
          end

          def room_for_extra_trains(entity)
            @game.num_extra_train(entity) < @game.train_limit(entity)
          end

          def room_for_regular_trains(entity)
            @game.num_corp_trains(entity) < @game.train_limit(entity)
          end

          def room?(entity, _shell = nil)
            room_for_extra_trains(entity) || room_for_regular_trains(entity)
          end
        end
      end
    end
  end
end
