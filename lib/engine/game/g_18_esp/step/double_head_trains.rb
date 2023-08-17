# frozen_string_literal: true

require_relative '../../../step/base'

module Engine
  module Game
    module G18ESP
      module Step
        class CombinedTrains < Engine::Step::Base
          ACTIONS = %w[combined_trains pass].freeze

          def description
            'Combine Trains'
          end

          def actions(entity)
            return [] unless entity == current_entity
            return [] unless entity.corporation?
            return [] unless @game.combined_obsolete_trains_candidates.size.positive?
            return [] unless @game.combined_base_trains_candidates(entity).size.positive?
            return [] unless @game.can_run_route?(entity)

            ACTIONS
          end

          def process_combined_trains(action)
            base = action.base
            additional_train = action.additional_train
            variant = action.additional_train_variant
            corporation = action.entity
            additional_train.variant = variant

            joined_trains = "#{base.name}, #{additional_train.name}"
            create_double_headed_train!(base, additional_train)

            @log << "#{corporation.name} forms "\
                    "#{base.name} train by combining trains: #{joined_trains}"
          end

          def create_double_headed_train!(base, additional_train)
            # double-headed train's ID is formed by combining the the IDs of the
            # given trains, so that if they are double headed this way again,
            # the double headed train does not need to be recreated, and the
            # route auto-selector can use its previous route
            distance, name = combined_distance_and_name(base, additional_train)

            # simplify name to C+t form, after id is set via sym
            base.name = name
            base.distance = distance
            base.track_type = :all

            @game.update_trains_cache

            @game.double_headed_trains << base
          end

          def combined_distance_and_name(base, additional_train)
            c, t = @game.distance(base)
            c1, t1 = @game.distance(additional_train)
            cities = c + c1
            towns = t + t1

            distance = [
              { 'nodes' => %w[town offboard halt], 'pay' => towns, 'visit' => towns },
              { 'nodes' => %w[city offboard town halt], 'pay' => cities, 'visit' => cities },
            ]

            name = "#{cities}+#{towns}C"

            [distance, name]
          end
        end
      end
    end
  end
end
