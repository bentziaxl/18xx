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
          ].freeze

        EVENTS_TEXT = Base::EVENTS_TEXT.merge(
          'south_majors_available' => ['South Majors Available',
                                       'Major Corporations in the south map can open'],
          'signal_end_game' => ['End Game',
                                'Game Ends at the end of complete set of ORs']
        ).freeze

        def new_auction_round
          Round::Auction.new(self, [
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
          Round::Operating.new(self, [
            Engine::Step::Bankrupt,
            Engine::Step::Exchange,
            Engine::Step::SpecialTrack,
            Engine::Step::SpecialToken,
            Engine::Step::BuyCompany,
            Engine::Step::HomeToken,
            Engine::Step::Track,
            Engine::Step::Token,
            Engine::Step::Route,
            Engine::Step::Dividend,
            Engine::Step::DiscardTrain,
            Engine::Step::BuyTrain,
            [Engine::Step::BuyCompany, { blocks: true }],
          ], round_num: round_num)
        end

        def setup
          @corporations, @future_corporations = @corporations.partition do |corporation|
            corporation.type == :minor || corp_north?(corporation)
          end
        end

        #   # The base route_distance just counts the visited stops on a route. This
        # # is valid but only for non-hex trains.
        # def hex_route_distance(route)
        #   route.chains.sum { |conn| hex_edge_cost(conn, route.train) }
        # end

        # def route_distance(route)
        #   return hex_route_distance(route) if route.train.name.include?('H')
        #   return plus_route_distance(route) if route.train.name.include?('+')

        #   super
        # end

        def corp_north?(corporation)
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
      end
    end
  end
end
