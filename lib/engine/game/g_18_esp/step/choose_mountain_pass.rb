# frozen_string_literal: true

require_relative '../../../step/base'

module Engine
  module Game
    module G18ESP
      module Step
        class ChooseMountainPass < Engine::Step::Base
          ACTIONS = %w[choose pass].freeze

          def actions(entity)
            return [] if !entity.corporation? || entity != current_entity

            return [] if @game.opening_new_mountain_pass(entity).empty?

            ACTIONS
          end

          def choice_name
            'Choose which Mountain Pass to open'
          end

          def choices
            @game.opening_new_mountain_pass(current_entity)
          end

          def description
            'Choose'
          end

          def process_choose(action)
            @game.open_mountain_pass(action.entity, action.choice)
            pass!
          end

          def skip!
            pass!
          end
        end
      end
    end
  end
end
