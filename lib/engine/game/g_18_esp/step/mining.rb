# frozen_string_literal: true

require_relative '../../../step/base'

module Engine
  module Game
    module G1848
      module Step
        class Mining < Engine::Step::Base

          ACTIONS = %w[buy_mea pass].freeze
          def actions(entity)
            puts("here")
            ACTIONS
          end

          def description
            'Buy MEA (Mining Exploitation Authorization)'
          end

          def process_buy_mea(action)
            puts("in buy mea")
          end
            
          
        end
      end
    end
  end
end
