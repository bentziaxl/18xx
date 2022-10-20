# frozen_string_literal: true

require_relative '../../../round/operating'

module Engine
  module Game
    module G18ESP
      module Round
        class Operating < Engine::Round::Operating
          attr_accessor :mea_hex

          def after_process(action)
            @game.fix_mine_token(@tokened_mountain_pass) if @tokened_mountain_pass
            super
          end

          def start_operating
            if current_entity.corporation? && @game.check_for_destination_connection(current_entity)
              current_entity.goal_reached!(:destination)
            end
            @mea_hex = nil
            super
          end
        end
      end
    end
  end
end
