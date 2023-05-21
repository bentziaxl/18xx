# frozen_string_literal: true

module Engine
  module Game
    module G18ESP
      class Corporation < Engine::Corporation
        attr_reader :destination, :goals_reached_counter
        attr_accessor :destination_connected, :ran_offboard, :ran_southern_map, :taken_over_minor, :moved_token

        def initialize(game, sym:, name:, **opts)
          @game = game
          @destination = opts[:destination]
          @goals_reached_counter = 0
          super(sym: sym, name: name, **opts)
          @tokens = opts[:tokens].map do |price|
            token = Token.new(self, price: price)
            token.used = true unless price.zero?
            token
          end
          first_token = @tokens.find { |t| t.used == true }
          first_token&.used = false
        end

        def destination_connected?
          @destination_connected
        end

        def ran_offboard?
          @ran_offboard
        end

        def ran_southern_map?
          @ran_southern_map
        end

        def goal_reached!(type)

          old_reached_counter = @goals_reached_counter
          destination_goal_reached! if type == :destination
          offboard_goal_reached! if type == :offboard
          ran_southern_map_goal_reached! if type == 'southern map'
          minor_takeover_reached! if type == :takeover

          return if old_reached_counter == @goals_reached_counter

          # give company extra money
          additional_capital = @par_price.price * @goals_reached_counter
          @game.bank.spend(additional_capital, self)
          # give company extra token
          blocked_token = tokens.find { |token| token.used == true && !token.hex }
          blocked_token&.used = false

          @game.log << "#{name} reached #{type} goal. " \
                       "#{name} receives #{@game.format_currency(additional_capital)} and an extra token"
        end

        def destination_goal_reached!
          return if @destination_connected

          @game.remove_dest_icon(self)
          @destination_connected = true
          @goals_reached_counter += 1
        end

        def offboard_goal_reached!
          return if @ran_offboard

          @ran_offboard = true
          @goals_reached_counter += 1
        end

        def ran_southern_map_goal_reached!
          return if @ran_southern_map

          @ran_southern_map = true
          @goals_reached_counter += 1
        end

        def minor_takeover_reached!
          return if @taken_over_minor || @game.north_corp?(self)

          @game.gain_token(self, nil) # gain token if triggered in phase 6. no impact if already swaped or gained
          @taken_over_minor = true
          @goals_reached_counter += 1
        end

        def runnable_trains
          trains = super
          trains = trains.dup.reject { |t| t.track_type == :narrow } if !@game.north_corp?(self) || type == :minor
          trains
        end

        def interchange?
          return false unless @game.north_corp?(self)

          tokens.any? { |t| t.hex && @game.valid_interchange?(t.hex.tile) }
        end
      end
    end
  end
end
