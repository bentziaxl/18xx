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
            super.reject { |t| t.name == 'F' }
          end

          def buyable_train_variants(train, entity)
            trains = super
            type = @game.north_corp?(entity) ? :broad : :narrow

            trains = trains.reject { |v| type?(v[:name], type) } if owns_type?(entity, type)
            trains
          end

          def type?(name, type)
            (name.include?('+') && type == :narrow) || (!name.include?('+') && type == :broad)
          end

          def owns_type?(entity, type)
            entity.trains&.any? { |t| t.track_type == type }
          end
        end
      end
    end
  end
end
