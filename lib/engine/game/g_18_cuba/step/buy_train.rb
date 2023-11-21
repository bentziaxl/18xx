# frozen_string_literal: true

require_relative '../../../step/base'
require_relative '../../../step/buy_train'

module Engine
  module Game
    module G18Cuba
      module Step
        class BuyTrain < Engine::Step::BuyTrain
          def buyable_trains(entity)
            # Cannot buy trains from corps in liquidation.
            track_type = entity.type == :minor ? :narrow : :broad
            super.select { |t| t.track == track_type }
          end
        end
      end
    end
  end
end