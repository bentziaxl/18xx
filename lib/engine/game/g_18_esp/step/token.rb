# frozen_string_literal: true

require_relative '../../../step/token'

module Engine
  module Game
    module G18ESP
      module Step
        class Token < Engine::Step::Token
          ACTIONS = %w[place_token remove_token pass].freeze

          def actions(entity)
            return [] unless entity == current_entity
            return [] unless can_place_token?(entity) || can_move_token?(entity)

            case @state
            when nil
              ACTIONS
            when :move_token
              %w[place_token]
            end
          end

          def setup
            super
            @round.tokened_mountain_pass = nil
          end

          def description
            'Place a Token or Move existing Token'
          end

          def process_place_token(action)
            if @state == :move_token
              raise GameError, "Can't place token in original spot" if @removed_token == action.city.hex

              action.entity.moved_token = true
              action.entity.tokens.find { |token| !token.used }.price = @game.phase.name.to_i <= 4 ? 40 : 80
            end
            super
          end

          def round_state
            super.merge(
              {
                tokened_mountain_pass: nil,
              }
            )
          end

          def place_token(entity, city, token)
            return unless token

            @round.tokened_mountain_pass = city if @game.mountain_pass?(city.hex)
            super(entity, city, token)
          end

          def can_move_token?(entity)
            return false unless entity.corporation?

            !entity.moved_token && entity.tokens.dup.count { |token| token.used && token.hex } > 1
          end

          def process_remove_token(action)
            @entity = action.entity
            token = action.city.tokens[action.slot]
            raise GameError, "Cannot remove #{token.corporation.name} token" unless token.corporation == @entity

            home_token = @entity.tokens.first == token
            raise GameError, 'Cannot remove home token' if home_token

            token.remove!
            @log << "Remove token from #{action.city.hex.name}"
            @removed_token = action.city.hex
            @state = :move_token
          end

          def can_replace_token?(entity, token)
            return true unless token

            token.corporation == entity
          end
        end
      end
    end
  end
end
