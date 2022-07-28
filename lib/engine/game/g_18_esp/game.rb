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

        BANK_CASH = 12_000

        CERT_LIMIT = { 3 => 27, 4 => 20, 5 => 16, 6 => 13 }.freeze

        STARTING_CASH = { 3 => 930, 4 => 700, 5 => 560, 6 => 460 }.freeze

        MARKET = [
          %w[60y
             67
             71
             76
             82
             90
             100p
             112
             126
             142
             160
             180
             200
             225
             250
             275
             300
             325
             350],
          %w[53y
             60y
             66
             70
             76
             82
             90p
             100
             112
             126
             142
             160
             180
             200
             220
             240
             260
             280
             300],
          %w[46y
             55y
             60y
             65
             70
             76
             82p
             90
             100
             111
             125
             140
             155
             170
             185
             200],
          %w[39o
             48y
             54y
             60y
             66
             71
             76p
             82
             90
             100
             110
             120
             130],
          %w[32o 41o 48y 55y 62 67 71p 76 82 90 100],
          %w[25b 34o 42o 50y 58y 65 67p 71 75 80],
          %w[18b 27b 36o 45o 54y 63 67 69 70],
          %w[10b 20b 30b 40o 50y 60y 67 68],
          ['', '10b', '20b', '30b', '40o', '50y', '60y'],
          ['', '', '10b', '20b', '30b', '40o', '50y'],
          ['', '', '', '10b', '20b', '30b', '40o'],
        ].freeze

        PHASES = [{ name: '2', train_limit: 4, tiles: [:yellow], operating_rounds: 1 },
                  {
                    name: '3',
                    on: '3',
                    train_limit: 4,
                    tiles: %i[yellow green],
                    operating_rounds: 2,
                    status: ['can_buy_companies'],
                  },
                  {
                    name: '4',
                    on: '4',
                    train_limit: 3,
                    tiles: %i[yellow green],
                    operating_rounds: 2,
                    status: ['can_buy_companies'],
                  },
                  {
                    name: '5',
                    on: '5',
                    train_limit: 2,
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
                    name: 'D',
                    on: 'D',
                    train_limit: 2,
                    tiles: %i[yellow green brown],
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
            variants: [
              { name: '8H', distance: 8, price: 700 },
            ],
          },
          ].freeze

        def new_auction_round
          Round::Auction.new(self, [
            G18ESP::Step::SelectionAuction,
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
      end
    end
  end
end
