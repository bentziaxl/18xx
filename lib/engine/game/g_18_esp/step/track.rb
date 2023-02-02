# frozen_string_literal: true

require_relative '../../../step/track'
require_relative 'tracker'

module Engine
  module Game
    module G18ESP
      module Step
        class Track < Engine::Step::TrackAndToken
          include Engine::Game::G18ESP::Tracker

          def actions(entity)
            return [] unless entity == current_entity
            return [] if entity.company?

            actions = []
            actions << 'lay_tile' if can_lay_tile?(entity)
            actions << 'choose' if opening_mountain_pass?(entity)
            actions += %w[place_token remove_token] if can_place_token?(entity) || can_move_token?(entity)
            actions << 'pass' if actions.any?

            case @state
            when nil
              actions
            when :move_token
              %w[place_token]
            end
          end

          def setup
            super
            @round.tokened_mountain_pass = nil
            @tokened = false
          end

          def process_place_token(action)
            if @state == :move_token
              raise GameError, "Can't place token in original spot" if @removed_token == action.city.hex

              action.entity.moved_token = true
              action.entity.tokens.find { |token| !token.used }.price = move_token_price
            end
            super
            @game.graph.clear
            @game.broad_graph.clear
          end

          def round_state
            super.merge(
              {
                tokened_mountain_pass: nil,
              }
            )
          end

          def min_token_price(tokens)
            return super unless @state == :move_token

            move_token_price
          end

          def move_token_price
            @game.phase.name.to_i <= 4 ? 40 : 80
          end

          def place_token(entity, city, token)
            return unless token

            @round.tokened_mountain_pass = city if @game.mountain_pass?(city.hex)
            super(entity, city, token)
            @state = nil
          end

          def can_move_token?(entity)
            return false unless entity.corporation?

            !entity.moved_token && entity.tokens.dup.count do |token|
              token.used && token.hex
            end > 1 && entity.cash > move_token_price
          end

          def process_remove_token(action)
            @entity = action.entity
            token = action.city.tokens[action.slot]
            raise GameError, "Cannot remove #{token.corporation.name} token" unless token.corporation == @entity

            home_token = @entity.tokens.first == token
            raise GameError, 'Cannot remove home token' if home_token

            token.type = :normal if token.type == :neutral
            token.remove!
            @log << "Remove token from #{action.city.hex.name}"
            @removed_token = action.city.hex
            @state = :move_token
          end

          def can_replace_token?(entity, token)
            return true unless token

            token.corporation == entity
          end

          def help
            help_text = ['Once a game a corporation can move a non-home token to another location.']
            help_text << 'Click on the city with the token to remove, then another city to place the token.'
            help_text if can_move_token?(current_entity)
          end

          def opening_mountain_pass?(entity)
            entity.type != :minor && @game.opening_new_mountain_pass(entity).any?
          end

          def choice_name
            'Choose which Mountain Pass to open'
          end

          def choices
            @game.opening_new_mountain_pass(current_entity)
          end

          # def description
          #   desc = ''
          #   desc += 'Lay/Upgrade Track' if actions.include?('lay_tile')
          #   desc += 'Open Mountain Pass' if actions.include?('choose')
          #   desc
          # end

          def process_choose(action)
            @game.open_mountain_pass(action.entity, action.choice)
            @game.graph_for_entity(action.entity).clear
          end

          def skip!
            pass!
          end

          def process_pass(action)
            if action.entity.companies.find { |comp| comp.sym == 'MEA' }
              raise GameError, 'The MEA must be used in the same OR it was purchased'
            end

            super
          end
        end
      end
    end
  end
end
