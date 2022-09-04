# frozen_string_literal: true

require_relative 'meta'
require_relative 'map'
require_relative 'entities'
require_relative '../base'

module Engine
  module Game
    module G18ESP
      class Game < Game::Base
        include_meta(G18ESP::Meta)
        include Entities
        include Map

        CURRENCY_FORMAT_STR = '$%d'

        BANK_CASH = 99_999

        CERT_LIMIT = { 3 => 27, 4 => 20, 5 => 16, 6 => 13 }.freeze

        STARTING_CASH = { 3 => 930, 4 => 700, 5 => 560, 6 => 460 }.freeze

        NORTH_CORPS = %w[FdSB FdLR CFEA CFLG].freeze

        SELL_AFTER = :operate

        SELL_BUY_ORDER = :sell_buy

        NORTH_SOUTH_DIVIDE = 13

        MUST_BUY_TRAIN = :always

        BASE_MINE_BONUS = 10

        BASE_F_TRAIN = 10

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
             300
             325
             350
             375
             400
             425
             450],
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
             280
             300
             325
             350
             375
             400
             425],
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
             260
             280
             300
             325
             350
             375
             400],
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
             240
             260
             280
             300
             325
             350
             375],
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
             222
             240
             260
             280
             300
             325
             350],
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
             204
             222
             240
             260
             280
             300
             325],
        ].freeze

        STOCKMARKET_COLORS = Base::STOCKMARKET_COLORS.merge(
          par_overlap: :blue
        ).freeze

        MARKET_TEXT = {
          par: 'Major Corporation Par',
          par_overlap: 'Minor Corporation Par',
        }.freeze

        PHASES = [{
          name: '2',
          train_limit: 4,
          tiles: [:yellow],
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
            num: 15,
            rusts_on: '4',
            variants: [
              { name: '2H', distance: 2, price: 70 },
              {
                name: '1+2',
                distance: [{ 'nodes' => %w[city offboard], 'pay' => 1, 'visit' => 1 },
                           { 'nodes' => ['town'], 'pay' => 2, 'visit' => 2 }],
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
            num: 12,
            rusts_on: '6',
            variants: [
              { name: '3H', distance: 3, price: 150 },
              {
                name: '2+3',
                distance: [{ 'nodes' => %w[city offboard], 'pay' => 2, 'visit' => 2 },
                           { 'nodes' => ['town'], 'pay' => 3, 'visit' => 3 }],
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
              { name: '4H', distance: 4, price: 260 },
              {
                name: '3+4',
                distance: [{ 'nodes' => %w[city offboard], 'pay' => 3, 'visit' => 3 },
                           { 'nodes' => ['town'], 'pay' => 4, 'visit' => 4 }],
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
              { name: '5H', distance: 5, price: 450 },
              {
                name: '4+',
                distance: [{ 'nodes' => %w[city offboard], 'pay' => 4, 'visit' => 4 },
                           { 'nodes' => ['town'], 'pay' => 99, 'visit' => 99 }],
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
              { name: '6H', distance: 6, price: 530 },
              {
                name: '5+',
                distance: [{ 'nodes' => %w[city offboard], 'pay' => 5, 'visit' => 5 },
                           { 'nodes' => ['town'], 'pay' => 99, 'visit' => 99 }],
                track_type: :narrow,
                price: 600,
              },
            ],
          },

          {
            name: '8',
            distance: 8,
            price: 800,
            num: 50,
            events: [{ 'type' => 'renfe_founded' },
                     { 'type' => 'signal_end_game' }],
            variants: [
              { name: '8H', distance: 8, price: 700 },
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
              min_price: stock_market.par_prices.map(&:price).min,
              capitalization: self.class::CAPITALIZATION,
              **corporation.merge(corporation_opts),
            )
          end
        end

        def new_auction_round
          Engine::Round::Auction.new(self, [
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
            Engine::Step::HomeToken,
            G18ESP::Step::Mining,
            G18ESP::Step::SpecialTrack,
            G18ESP::Step::Track,
            Engine::Step::Token,
            G18ESP::Step::Route,
            G18ESP::Step::Dividend,
            Engine::Step::DiscardTrain,
            G18ESP::Step::BuyTrain,
            [Engine::Step::BuyCompany, { blocks: true }],
          ], round_num: round_num)
        end

        def setup
          @corporations, @future_corporations = @corporations.partition do |corporation|
            corporation.type == :minor || north_corp?(corporation)
          end
        end

        def tile_lays(entity)
          return MINOR_TILE_LAYS if entity.type == :minor
          return MAJOR_TILE_LAYS if entity.type == :major
        end

        def north_corp?(corporation)
          NORTH_CORPS.include? corporation.name
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

        def mea
          @mea ||= company_by_id('MEA')
        end

        def mine_hexes
          @mine_hexes ||= Entities::MINE_HEXES
        end

        def mine_hex?(hex)
          mine_hexes.any?(hex.name)
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

        def check_distance(route, visits, _train = nil)
          return super if route.train.name != 'F' || f_train_correct_route?(route, visits, @round.mea_hex)

          raise GameError, 'Route must connect Mine Tile placed and home token'
        end

        def revenue_for(route, stops)
          return super unless route.train.name == 'F'

          non_halt_stops = stops.count { |stop| !stop.is_a?(Part::Halt) }
          total_count = non_halt_stops + route.all_hexes.count { |hex| MINE_HEXES.include?(hex.name) }
          total_count * BASE_F_TRAIN
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
      end
    end
  end
end
