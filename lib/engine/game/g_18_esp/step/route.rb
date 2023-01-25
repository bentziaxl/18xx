# frozen_string_literal: true

require_relative '../../../step/route'

module Engine
  module Game
    module G18ESP
      module Step
        class Route < Engine::Step::Route
          def actions(entity)
            return [] if !entity.operator? || entity.runnable_trains.empty? || !@game.can_run_route?(entity)

            @luxury_train ||= nil
            actions = ACTIONS.dup
            actions << 'choose' if !@luxury_train && luxury_ability(entity) && !luxury_train_choices(entity).empty?
            actions
          end

          def choice_name
            'Choose which train you want to attach a luxury carriage'
          end

          def choices
            choices = {}
            luxury_train_choices(current_entity).each_with_index do |train, index|
              choices[index.to_s] = "#{train.name} train"
            end
            choices
          end

          def process_choose(action)
            entity = action.entity
            @luxury_train = luxury_train_choices(entity)[action.choice.to_i]
            @log << "#{entity.id} chooses to attach the luxury carriage to the #{@luxury_train.name} train"

            attach_luxury
          end

          def attach_luxury
            @orginal_train = @luxury_train.dup
            distance = @luxury_train.distance
            @luxury_train.name += '+1'
            @luxury_train.distance = [{ 'nodes' => ['town'], 'pay' => 1, 'visit' => 1 },
                                      { 'nodes' => %w[city offboard town], 'pay' => distance, 'visit' => distance }]
          end

          def luxury_ability(entity)
            entity.all_abilities.find { |a| a.descroption == 'Luxury Carriage' }
          end

          def luxury_train_choices(entity)
            @game.route_trains(entity).reject do |t|
              t.track_type == :narrow || t.name == 'F'
            end
          end

          def detach_luxury
            @luxury_train.name = @orginal_train.name
            @luxury_train.distance = @orginal_train.distance

            @orginal_train = nil
            @luxury_train = nil
          end

          def process_run_routes(action)
            action.entity.goal_reached!(:offboard) if @game.check_offboard_goal(action.entity, action.routes)
            action.entity.goal_reached!('southern map') if @game.check_southern_map_goal(action.entity, action.routes)
            super

            detach_luxury if @luxury_train
          end
        end
      end
    end
  end
end
