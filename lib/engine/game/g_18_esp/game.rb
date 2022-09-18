# frozen_string_literal: true

require_relative 'meta'
require_relative 'map'
require_relative 'entities'
require_relative '../base'
require_relative '../cities_plus_towns_route_distance_str'

module Engine
  module Game
    module G18ESP
      class Game < Game::Base
        include_meta(G18ESP::Meta)
        include Entities
        include Map
        include CitiesPlusTownsRouteDistanceStr

        attr_reader :minors_graph

        CURRENCY_FORMAT_STR = '$%d'

        BANK_CASH = 99_999

        CERT_LIMIT = { 3 => 27, 4 => 20, 5 => 16, 6 => 13 }.freeze

        STARTING_CASH = { 3 => 930, 4 => 700, 5 => 560, 6 => 460 }.freeze

        NORTH_CORPS = %w[FdSB FdLR CFEA CFLG].freeze

        SPECIAL_MINORS = %w[MS AC].freeze

        MOUNTAIN_PASS_ACCESS_HEX = %w[D19 E20 F21 G20 H19 I18 J17 E10 I10 K8 L7].freeze

        MOUNTAIN_PASS_HEX = %w[M8 K10 I12 E12 E18 F19 G18 H17 I16].freeze

        MOUNTAIN_PASS_TOKEN_HEXES = %w[M8 K10 I12 E12].freeze

        MOUNTAIN_PASS_TOKEN_COST = { 'M8' => 120, 'K10' => 120, 'I12' => 100, 'E12' => 160 }.freeze

        MOUNTAIN_PASS_TOKEN_BONUS = { 'M8' => 50, 'K10' => 30, 'I12' => 40, 'E12' => 40 }.freeze

        SELL_AFTER = :operate

        SELL_BUY_ORDER = :sell_buy

        NORTH_SOUTH_DIVIDE = 13

        MUST_BUY_TRAIN = :always

        BASE_MINE_BONUS = 10

        BASE_F_TRAIN = 10

        NEXT_SR_PLAYER_ORDER = :least_cash

        DISCARDED_TRAIN_DISCOUNT = 50

        CONTINUOUS_MARKET = true

        MINOR_TILE_LAYS = [{ lay: true, upgrade: true, cost: 0 }].freeze
        MAJOR_TILE_LAYS = [
          { lay: true, upgrade: true, cost: 0 },
          { lay: true, upgrade: false, cost: 20 },
        ].freeze

        MARKET = [
          %w[76
             82
             90
             100
             110
             120
             132
             144
             158
             172
             188
             204
             222
             240
             260
             280
             300i
             325i
             350i
             375i
             400i
             425i
             450i],
          %w[72
             76
             82
             90
             100
             110
             120
             132
             144
             158
             172
             188
             204
             222
             240
             260
             280i
             300i
             325i
             350i
             375i
             400i
             425i],
          %w[68p
             72p
             76p
             82p
             90p
             100p
             110
             120
             132
             144
             158
             172
             188
             204
             222
             240
             260i
             280i
             300i
             325i
             350i
             375i
             400i],
          %w[64
             68
             72
             76
             82
             90
             100
             110
             120
             132
             144
             158
             172
             188
             204
             222
             240i
             260i
             280i
             300i
             325i
             350i
             375i],
          %w[60P
             64P
             68P
             72P
             76P
             82P
             90
             100
             110
             120
             132
             144
             158
             172
             188
             204
             222i
             240i
             260i
             280i
             300i
             325i
             350i],
          %w[56
             60
             64
             68
             72
             76
             82
             90
             100
             110
             120
             132
             144
             158
             172
             188
             204i
             222i
             240i
             260i
             280i
             300i
             325i],
        ].freeze

        STOCKMARKET_COLORS = Base::STOCKMARKET_COLORS.merge(
          par_overlap: :blue
        ).freeze

        MARKET_TEXT = Base::MARKET_TEXT.merge(
          par: 'Major Corporation Par',
          par_overlap: 'Minor Corporation Par',
        ).freeze

        PHASES = [{
          name: '2',
          train_limit: 4,
          tiles: %i[yellow],
          operating_rounds: 1,
        },
                  {
                    name: '3',
                    on: '3',
                    train_limit: 4,
                    tiles: %i[yellow green],
                    operating_rounds: 2,
                    status: ['train_conversions'],
                  },
                  {
                    name: '4',
                    on: '4',
                    train_limit: { minor: 1, major: 3 },
                    tiles: %i[yellow green],
                    operating_rounds: 2,
                  },
                  {
                    name: '5',
                    on: '5',
                    train_limit: 3,
                    tiles: %i[yellow green brown],
                    operating_rounds: 3,
                  },
                  {
                    name: '6',
                    on: '6',
                    train_limit: 2,
                    tiles: %i[yellow green brown],
                    operating_rounds: 3,
                  },
                  {
                    name: '8',
                    on: 'D',
                    train_limit: 2,
                    tiles: %i[yellow green brown gray],
                    operating_rounds: 3,
                  }].freeze

        TRAINS = [

          {
            name: '2',
            distance: 2,
            price: 90,
            num: 12,
            rusts_on: '4',
            variants: [
              {
                name: '1+1',
                distance: [{ 'nodes' => %w[city offboard], 'pay' => 1, 'visit' => 1 },
                           { 'nodes' => ['town'], 'pay' => 1, 'visit' => 1 }],
                track_type: :narrow,
                no_local: true,
                price: 70,
              },
            ],
          },
          {
            name: '3',
            distance: 3,
            price: 180,
            num: 10,
            rusts_on: '6',
            variants: [
              {
                name: '2+2',
                distance: [{ 'nodes' => %w[city offboard], 'pay' => 2, 'visit' => 2 },
                           { 'nodes' => ['town'], 'pay' => 2, 'visit' => 2 }],
                track_type: :narrow,
                price: 200,
              },
            ],
            events: [{ 'type' => 'south_majors_available' }],
          },
          {
            name: '4',
            distance: 4,
            price: 300,
            num: 8,
            rusts_on: '8',
            variants: [
              {
                name: '3+3',
                distance: [{ 'nodes' => %w[city offboard], 'pay' => 3, 'visit' => 3 },
                           { 'nodes' => ['town'], 'pay' => 3, 'visit' => 3 }],
                track_type: :narrow,
                price: 300,
              },
            ],
          },
          {
            name: '5',
            distance: 5,
            price: 500,
            num: 4,
            variants: [
              {
                name: '4+4',
                distance: [{ 'nodes' => %w[city offboard], 'pay' => 4, 'visit' => 4 },
                           { 'nodes' => ['town'], 'pay' => 4, 'visit' => 4 }],
                track_type: :narrow,
                price: 500,
              },
            ],
            events: [{ 'type' => 'close_companies' },
                     { 'type' => 'open_mountain_passes' }],
          },
          {
            name: '6',
            distance: 6,
            price: 600,
            num: 4,
            variants: [
              {
                name: '5+5',
                distance: [{ 'nodes' => %w[city offboard], 'pay' => 5, 'visit' => 5 },
                           { 'nodes' => ['town'], 'pay' => 5, 'visit' => 5 }],
                track_type: :narrow,
                price: 600,
              },
            ],
          },

          {
            name: '8',
            distance: 8,
            price: 800,
            num: 30,
            events: [{ 'type' => 'renfe_founded' },
                     { 'type' => 'signal_end_game' }],
            variants: [
                      {
                        name: '5+5',
                        distance: [{ 'nodes' => %w[city offboard], 'pay' => 5, 'visit' => 5 },
                                   { 'nodes' => ['town'], 'pay' => 5, 'visit' => 5 }],
                        track_type: :narrow,
                        price: 600,
                      },
                    ],

          },
          {
            name: 'F',
            distance: 99,
            price: 0,
            num: 1,
            available_on: '2',
            track_type: :dual,
          },
          ].freeze

        FREIGHT_TRAIN = [{
          name: :F,
          distance: 99,
          price: 0,
          num: 50,
          buyable: false,
        }].freeze

        EVENTS_TEXT = Base::EVENTS_TEXT.merge(
                'south_majors_available' => ['South Majors Available',
                                             'Major Corporations in the south map can open'],
                'signal_end_game' => ['End Game',
                                      'Game Ends at the end of complete set of ORs'],
              ).freeze

        def init_corporations(stock_market)
          game_corporations.map do |corporation|
            G18ESP::Corporation.new(
              self,
              min_price: stock_market.par_prices.map(&:price).min,
              capitalization: self.class::CAPITALIZATION,
              **corporation.merge(corporation_opts),
            )
          end
        end

        def new_auction_round
          Engine::Round::Auction.new(self, [
            G18ESP::Step::CompanyPendingPar,
            G18ESP::Step::SelectionAuction,
          ])
        end

        def stock_round
          Engine::Round::Stock.new(self, [
            Engine::Step::DiscardTrain,
            G18ESP::Step::BuySellParShares,
          ])
        end

        def operating_round(round_num)
          G18ESP::Round::Operating.new(self, [
            Engine::Step::Bankrupt,
            Engine::Step::Exchange,
            Engine::Step::SpecialToken,
            Engine::Step::BuyCompany,
            G18ESP::Step::HomeToken,
            G18ESP::Step::Mining,
            G18ESP::Step::SpecialTrack,
            G18ESP::Step::Track,
            G18ESP::Step::ChooseMountainPass,
            G18ESP::Step::Token,
            G18ESP::Step::Route,
            G18ESP::Step::Dividend,
            Engine::Step::DiscardTrain,
            G18ESP::Step::Acquire,
            G18ESP::Step::BuyTrain,
            [Engine::Step::BuyCompany, { blocks: true }],
          ], round_num: round_num)
        end

        def setup
          @corporations, @future_corporations = @corporations.partition do |corporation|
            corporation.type == :minor || north_corp?(corporation)
          end

          @corporations.each { |c| c.shares.last.buyable = false unless c.type == :minor }
          @minors_graph = Graph.new(self, home_as_token: true)
        end

        def init_company_abilities
          northern_corps = @corporations.select { |c| north_corp?(c) }
          random_corporation = northern_corps[rand % northern_corps.size]
          @companies.each do |company|
            next unless (ability = abilities(company, :shares))

            real_shares = []
            ability.shares.each do |share|
              case share
              when 'random_president'
                share = random_corporation.shares[0]
                real_shares << share
                company.desc = "Purchasing player takes a president's share (20%) of #{random_corporation.name} \
                and immediately sets its par value."
                @log << "#{company.name} comes with the president's share of #{random_corporation.name}"
                company.add_ability(Ability::Close.new(
                type: :close,
                when: 'bought_train',
                corporation: random_corporation.name,
              ))
              else
                real_shares << share_by_id(share)
              end
            end

            ability.shares = real_shares
          end
        end

        def tile_lays(entity)
          return MINOR_TILE_LAYS if entity.type == :minor
          return MAJOR_TILE_LAYS if entity.type == :major
        end

        def north_corp?(entity)
          return false unless entity&.corporation?

          NORTH_CORPS.include? entity.name
        end

        def event_south_majors_available!
          @corporations.concat(@future_corporations)
          @log << '-- Major corporations in the south now available --'
        end

        # market
        def par_prices(corp)
          par_type = corp.type == 'major' ? %i[par] : %i[par_overlap]
          stock_market.share_prices_with_types(par_type)
        end

        def float_corporation(corporation)
          @log << "#{corporation.name} floats"
          share_count = corporation.type == 'major' ? 4 : 2

          @bank.spend(corporation.par_price.price * share_count, corporation)
          @log << "#{corporation.name} receives #{format_currency(corporation.cash)}"
        end

        def north_hex?(hex)
          hex.y << NORTH_SOUTH_DIVIDE
        end

        def mountain_pass_access?(hex)
          MOUNTAIN_PASS_ACCESS_HEX.include?(hex&.id)
        end

        def mountain_pass?(hex)
          MOUNTAIN_PASS_HEX.include?(hex.id)
        end

        def mea
          @mea ||= company_by_id('MEA')
        end

        def mine_hexes
          @mine_hexes ||= Entities::MINE_HEXES
        end

        def mine_hex?(hex)
          mine_hexes.any?(hex.name)
        end

        def opened_mountain_passes
          @opened_mountain_passes  ||= {}
        end

        def f_train
          @depot.trains.find { |t| t.name == 'F' }
        end

        def discard_f_train(action)
          corp = action.entity
          f_train = corp.trains.find { |train| train&.name == 'F' }
          f_train&.owner = nil
          corp.trains.delete(f_train)
          @log << 'F train discarded'
        end

        def upgrade_cost(old_tile, hex, entity, spender)
          total_cost = super
          hex.tile.paths.all? { |path| path.track == :narrow } ? total_cost / 2 : total_cost
        end

        def subsidy_for(route, _stops)
          return 0 if route.train.name == 'F'

          count = route.all_hexes.count { |hex| MINE_HEXES.include?(hex.name) }
          count * BASE_MINE_BONUS
        end

        def routes_subsidy(routes)
          routes.sum(&:subsidy)
        end

        def check_other(route)
          check_track_type(route)
        end

        def check_track_type(route)
          track_types = route.chains.flat_map { |item| item[:paths] }.flat_map(&:track).uniq

          if route.train.track_type == :narrow && !(track_types - [:narrow] - [:dual]).empty?
            raise GameError,
                  'Route may only contain narrow tracks'
          end

          if route.train.track_type == :broad && !(track_types - [:broad] - [:dual]).empty?
            raise GameError, 'Route may only contain broad tracks'
          end

          nil
        end

        def f_train_correct_route?(route, visits, mea_hex)
          start_city = route.train.owner.tokens.first
          (visits.first.hex == mea_hex || visits.first.hex == start_city.hex) &&
          (visits.last.hex == mea_hex || visits.last.hex == start_city.hex)
        end

        def train_type(train)
          train.name == 'F' ? :freight : :passenger
        end

        def check_overlap(routes)
          tracks_by_type = Hash.new { |h, k| h[k] = [] }

          routes.each do |route|
            route.paths.each do |path|
              a = path.a
              b = path.b

              tracks = tracks_by_type[train_type(route.train)]
              tracks << [path.hex, a.num, path.lanes[0][1]] if a.edge?
              tracks << [path.hex, b.num, path.lanes[1][1]] if b.edge?
            end
          end
          tracks_by_type.each do |_type, tracks|
            tracks.group_by(&:itself).each do |k, v|
              raise GameError, "Route cannot reuse track on #{k[0].id}" if v.size > 1
            end
          end
        end

        def compute_other_paths(routes, route)
          routes
            .reject { |r| r == route }
            .select { |r| train_type(route.train) == train_type(r.train) }
            .flat_map(&:paths)
        end

        def check_for_destination_connection(entity)
          return false unless entity.corporation?
          return true if entity.destination_connected?

          graph = Graph.new(self, home_as_token: true, no_blocking: true)
          graph.compute(entity)
          graph.reachable_hexes(entity).include?(hex_by_id(entity.destination))
        end

        def check_offboard_goal(entity, routes)
          return false unless entity.corporation?
          return false if entity.type == :minor
          return true if entity.ran_offboard?

          # logic to check if routes include offboard
          routes.any? { |route| route.visited_stops.any?(&:offboard?) }
        end

        def check_southern_map_goal(entity, routes)
          return false unless entity.corporation?
          return false unless north_corp?(entity)
          return false if entity.type == :minor
          return true if entity.ran_southern_map?

          # logic to check if narrow track train connects to target cities
          routes.any? do |route|
            next unless route.train.track_type == :narrow

            route.visited_stops.any? { |stop| stop.hex.id == 'I16' || stop.hex.id == 'E18' }
          end
        end

        def open_mountain_pass(entity, pass_hex)
          pass_tile = hex_by_id(pass_hex).tile
          track_type = north_corp?(entity) ? :narrow : :broad

          pass_tile.paths.each do |path|
            path.walk { |p| p.track = track_type if p.tile.color == :orange }
          end

          mount_pass_cost = mountain_pass_token_cost(hex_by_id(pass_hex))
          entity.spend(mount_pass_cost, @bank)

          opened_mountain_passes[pass_hex] = track_type

          @log << "#{entity.name} spends #{format_currency(mount_pass_cost)} to open mountain pass"
        end

        def opening_new_mountain_pass(entity)
          return {} unless entity

          openable_passes = @graph.reachable_hexes(entity).keys.select { |hex| mountain_pass_token_hex?(hex) }
          openable_passes = openable_passes.reject { |hex| opened_mountain_passes.key?(hex.id) }

          return {} if openable_passes.empty? || last_track_type?(entity, openable_passes)

          openable_passes = [openable_passes.first] if north_corp?(entity)
          openable_passes.to_h { |hex| [hex.id, "#{hex.location_name} (#{format_currency(mountain_pass_token_cost(hex))})"] }
        end

        def last_track_type?(_entity, openable_passes)
          return false unless openable_passes.length == 1

          opened_passes_uniq = opened_mountain_passes.values.uniq
          last_pass_different = opened_passes_uniq.length == 1 && opened_mountain_passes.length == 3
          return false unless last_pass_different

          proposed_track_type = north_corp? ? :narrow : :broad

          return false unless opened_passes_uniq.first == proposed_track_type

          @log << 'Last mountain pass must be of a different track type, skipping opening mountain pass'
          true
        end

        def mountain_pass_token_cost(hex)
          MOUNTAIN_PASS_TOKEN_COST[hex.id]
        end

        def mountain_pass_token_hex?(hex)
          MOUNTAIN_PASS_TOKEN_HEXES.include?(hex.id)
        end

        def visited_stops(route)
          route_stops = super
          route_stops.reject { |stop| mountain_pass_token_hex?(stop.hex) && stop.tokened_by?(route.train.owner) }
        end

        def check_distance(route, visits, train = nil)
          unless route.train.name != 'F' || f_train_correct_route?(route, visits, @round.mea_hex)
            raise GameError, 'Route must connect Mine Tile placed and home token'
          end

          if mountain_pass_token_hex?(route.hexes.first) || mountain_pass_token_hex?(route.hexes.last)
            raise GameError,
                  'Route can not end or start in Mountain pass'
          end

          raise GameError, 'Route can only use one mountain pass' if route.hexes.count { |hex| mountain_pass_token_hex?(hex) } > 1

          train ||= route.train
          distance = train.distance
          if distance.is_a?(Numeric)
            route_distance = visits.sum(&:visit_cost)
            raise RouteTooLong, "#{route_distance} is too many stops for #{distance} train" if distance < route_distance

            return
          end

          type_info = Hash.new { |h, k| h[k] = [] }

          distance.each do |h|
            pay = h['pay']
            visit = h['visit'] || pay
            info = { pay: pay, visit: visit }
            h['nodes'].each do |type|
              type_info[type] << info
            end
          end

          grouped = visits.group_by { |visit| mountain_pass_token_hex?(visit.hex) ? 'town' : visit.type }

          grouped.sort_by { |t, _| type_info[t].size }.each do |type, group|
            num = group.sum(&:visit_cost)

            type_info[type].each do |info|
              next unless info[:visit].positive?

              if num <= info[:visit]
                info[:visit] -= num
                num = 0
              else
                num -= info[:visit]
                info[:visit] = 0
              end

              break unless num.positive?
            end

            raise RouteTooLong, 'Route has too many stops' if num.positive?
          end
        end

        def revenue_for_f(route, stops)
          non_halt_stops = stops.count { |stop| !stop.is_a?(Part::Halt) }
          total_count = non_halt_stops + route.all_hexes.count { |hex| MINE_HEXES.include?(hex.name) }
          total_count * BASE_F_TRAIN
        end

        def revenue_for(route, stops)
          return revenue_for_f(route, stops) if route.train.name == 'F'

          bonus = route.hexes.sum do |hex|
            tokened_mountain_pass(hex, route.train.owner) ? MOUNTAIN_PASS_TOKEN_BONUS[hex.id] : 0
          end

          super + bonus
        end

        def tokened_mountain_pass(hex, entity)
          mountain_pass_token_hex?(hex) &&
          hex.tile.stops.first.tokened_by?(entity)
        end

        def revenue_str(route)
          return super unless route.hexes.any? { |hex| mountain_pass_token_hex?(hex) }

          super + ' + mountain pass'
        end

        def route_distance_str(route)
          towns = route.visited_stops.count { |visit| mountain_pass_token_hex?(visit.hex) ? 1 : visit.town? }
          cities = route_distance(route) - towns
          towns.positive? ? "#{cities}+#{towns}" : cities.to_s
        end

        def purchasable_companies(entity)
          return [] if north_corp?(entity)

          @corporations.select { |c| c.type == :minor }
        end

        def start_merge(corporation, minor, keep_token)
          # take over assets
          move_assets(corporation, minor)

          # handle token
          keep_token ? swap_token(corporation, minor) : gain_token(corporation, minor)

          # complete goal
          corporation.goal_reached!(:takeover)

          # pay compensation
          pay_compnesation(corporation, minor)

          # get share
          get_reserved_share(minor.owner, corporation)

          # close corp
          close_corporation(minor)
        end

        def pay_compnesation(corporation, minor)
          per_share = minor.share_price.price
          payouts = {}
          @players.each do |player|
            amount = player.num_shares_of(minor) * per_share
            next if amount.zero?

            amount -= corporation.share_price.price if minor.president?(player)
            next unless amount.positive?

            payouts[player] = amount
            @bank.spend(amount, player)
          end

          return if payouts.empty?

          receivers = payouts
                          .sort_by { |_r, c| -c }
                          .map { |receiver, cash| "#{receiver.name} gets #{format_currency(cash)} compensation " }.join(', ')

          @log << receivers.to_s
        end

        def get_reserved_share(owner, corporation)
          reserved_share = corporation.shares.find { |share| share.buyable == false }
          return unless reserved_share

          reserved_share.buyable = true
          @share_pool.transfer_shares(
              reserved_share.to_bundle,
              owner,
              allow_president_change: true,
              price: 0
            )
          @log << "#{owner.name} gets a share of #{corporation.name}"
        end

        def gain_token(corporation, minor)
          blocked_token = corporation.tokens.find { |token| token.used == true && !token.hex && token.price == 100 }
          blocked_token&.used = false
          delete_token(minor) if minor.name == 'MZ'
        end

        def delete_token(minor)
          token = minor.tokens.first
          return unless token.used

          token.city.delete_token!(token, remove_slot: true)
        end

        def swap_token(survivor, nonsurvivor)
          new_token = survivor.tokens.last
          old_token = nonsurvivor.tokens.first
          city = old_token.city
          return gain_token(survivor) unless city

          @log << "Replaced #{nonsurvivor.name} token in #{city.hex.id} with #{survivor.name} token"
          new_token.place(city)
          city.tokens[city.tokens.find_index(old_token)] = new_token
          nonsurvivor.tokens.delete(old_token)
        end

        def move_assets(survivor, nonsurvivor)
          # cash
          nonsurvivor.spend(nonsurvivor.cash, survivor) if nonsurvivor.cash.positive?
          # trains
          nonsurvivor.trains.each { |t| t.owner = survivor }
          survivor.trains.concat(nonsurvivor.trains)
          nonsurvivor.trains.clear
          survivor.trains.each { |t| t.operated = false }
          # privates
          nonsurvivor.companies.each do |c|
            c.owner = survivor
            owner.companies << c
          end

          @log << "Moved assets from #{nonsurvivor.name} to #{survivor.name}"
        end

        def must_buy_train?(entity)
          trains = entity.trains
          trains = trains.dup.reject { |t| t.track_type == :narrow } if !north_corp?(entity) || entity.type == :minor
          trains.empty? && !depot.depot_trains.empty?
        end

        def place_home_token(corporation)
          super unless special_minor?(corporation)
        end

        def graph_for_entity(entity)
          return unless entity.corporation?

          special_minor?(entity) ? @minors_graph : @graph
        end

        def special_minor?(corporation)
          SPECIAL_MINORS.include?(corporation.name)
        end
      end
    end
  end
end
