# frozen_string_literal: true

require_relative '../../../step/route'
require_relative 'skip_fc'

module Engine
  module Game
    module G18Cuba
      module Step
        class Route < Engine::Step::Route
          include SkipFc

          WAGON_CAPACITY =
            {
              '1w' => 1,
              '2w' => 2,
              '3w' => 3,
            }.freeze

          def setup
            @round.current_routes = {}
            @choosing = { state: :choose_wagon }
            @round.merged_trains = {}
          end

          def actions(entity)
            return [] if !entity.operator? || @game.route_trains(entity).empty? || !@game.can_run_route?(entity)

            actions = ACTIONS.dup
            actions << 'choose' if choosing?(entity)
            actions
          end

          def choosing?(_entity)
            @choosing
          end

          def choice_name
            case @choosing[:state]
            when :choose_wagon
              'Attach wagons to routes'
            when :choose_goods
              'Load goods to wagons'
            end
          end

          def choices
            case @choosing[:state]
            when :choose_wagon
              choices_wagons
            when :choose_goods
              choices_goods
            end
          end

          def choices_wagons
            choices = { skip: 'Skip' }
            wagons, trains = current_entity.trains.reject { |train| @round.merged_trains.key?(train) }
                              .partition { |t| @game.wagon?(t) }

            trains.select! { |t| route_for_train(t) }
            choices.merge!(trains.product(wagons).to_h do |train, wagon|
                             [[train.id, wagon.id], "attach #{wagon.name} to #{train.name}"]
                           end)
            choices
          end

          def choices_goods
            choices = {}
            @round.current_routes.values.select { |r| can_load_cubes?(r) }.each do |goods_route|
              next unless cube_capacity?(goods_route.train)

              route_sugar_cubes(goods_route).each do |cube_hex|
                @game.hex_by_id(cube_hex).assignments.keys.each do |a|
                  next unless a&.include? 'SUGAR'
                  next if @game.claimed_goods[cube_hex]&.include? a

                  choices[[goods_route.train.id, cube_hex]] = "Deliver sugar cube from #{cube_hex} on #{goods_route.train.name}"
                end
              end
            end
            choices
          end

          def can_load_cubes?(route)
            goods_route?(route) && @round.merged_trains.include?(route.train)
          end

          def cube_capacity?(train)
            cubes_on_train(train) <= wagon_capacity(train)
          end

          def cubes_on_train(train)
            pickup_hexes = @game.pickup_hex_for_train[train.id]
            return 0 unless pickup_hexes

            pickup_hexes.sum(&:count)
          end

          def wagon_capacity(train)
            name_parition = train.name.partition(' & ')
            return 0 unless name_parition.length > 1

            WAGON_CAPACITY[name_parition[2]]
          end

          def goods_route?(route)
            route_sugar_cubes(route) && route.visited_stops.any?(&:offboard?)
          end

          def route_for_train(train)
            return if train.nil?

            route = @round.current_routes[train]
            return unless route&.visited_stops&.count&.positive?

            route
          end

          def route_sugar_cubes(route)
            visits = route.visited_stops
            sugar_cubes = visits.map do |node|
              next unless node.city?

              node.hex.assignments.map { |_| node.hex.id }
            end
            sugar_cubes.compact.flatten
          end

          def process_choose(action)
            case @choosing[:state]
            when :choose_wagon
              process_choose_wagon(action)
            when :choose_goods
              process_choose_goods(action)
            end
          end

          def process_choose_wagon(action)
            if action.choice == :skip
              @choosing[:state] = :choose_goods
            else
              train = @game.train_by_id(action.choice[0])
              wagon = @game.train_by_id(action.choice[1])
              @log << "#{wagon.name} is attached to #{train.name}"
              train.name = "#{train.name} & #{wagon.name}"
              @round.merged_trains[train] = wagon
            end
          end

          def process_choose_goods(action)
            train_id = action.choice[0]
            hex_id = action.choice[1]
            @game.attach_good_to_train(train_id, hex_id)
          end

          def process_run_routes(action)
            super
            gain_sugar_cubes(action.entity, @game.routes_revenue(@round.routes)) if action.entity.type == :minor
            # remove cubes from each route
            remove_cubes_from_routes(action.routes)
            # detach wagons
            detach_wagons(action.routes)
          end

          def detach_wagons(_routes)
            @round.merged_trains.dup.keys.each do |train|
              wagon = @round.merged_trains[train]
              train.name = train.name.sub(" & #{wagon.name}", '')
              @log << "#{wagon.name} is removed from #{train.name}"
              @round.merged_trains.delete(train)
            end
          end

          def remove_cubes_from_routes(routes)
            routes.each do |route|
              pickup_hexes = @game.pickup_hex_for_train[route.train.id]
              next unless pickup_hexes

              pickup_hexes.keys.each do |hex_id|
                pickup_hexes[hex_id].each { |good| @game.hex_by_id(hex_id)&.remove_assignment!(good) }
                @game.unload_good(route.train, hex_id)
              end
            end
          end

          def gain_sugar_cubes(corp, revenue)
            sugar_cubes = case revenue
                          when 0..20 then 0
                          when 30..70 then 1
                          when 80..150 then 2
                          else 3
                          end

            return unless sugar_cubes.positive?

            @game.log << "#{corp.name} gains #{sugar_cubes} sugar cube(s)"
            home_city_hex = corp.tokens.first.city.hex
            sugar_cubes.times { |index| home_city_hex.assign!("SUGAR#{index}") }

            @game.sugar_cubes[corp] += sugar_cubes
          end

          def round_state
            super.merge({ current_routes: {}, merged_trains: {} })
          end
        end
      end
    end
  end
end
