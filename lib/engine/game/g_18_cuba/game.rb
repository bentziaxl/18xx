# frozen_string_literal: true

require_relative 'entities'
require_relative 'map'
require_relative 'meta'
require_relative '../base'
require_relative '../double_sided_tiles'

module Engine
  module Game
    module G18Cuba
      class Game < Game::Base
        include_meta(G18Cuba::Meta)
        include Entities
        include Map

        include DoubleSidedTiles

        attr_reader :tile_groups, :unused_tiles, :minor_graph

        register_colors(red: '#d1232a',
                        orange: '#f58121',
                        black: '#110a0c',
                        blue: '#025aaa',
                        lightBlue: '#8dd7f6',
                        yellow: '#ffe600',
                        green: '#32763f',
                        brightGreen: '#6ec037')
        TRACK_RESTRICTION = :permissive
        CURRENCY_FORMAT_STR = '$%s'

        COMPANY_CONCESSION_PREFIX = 'M'
        COMPANY_COMMISIONER_PREFIX = 'C'

        CONCESSION_DISCOUNT = 210

        NEXT_SR_PLAYER_ORDER = :least_cash

        SELL_AFTER = :operate

        CAPITALIZATION = :incremental

        ALLOW_REMOVING_TOWNS = true

        BANK_CASH = 10_000

        CERT_LIMIT = { 2 => 35, 3 => 30, 4 => 20, 5 => 17, 6 => 15 }.freeze

        STARTING_CASH = { 2 => 950, 3 => 900, 4 => 680, 5 => 650, 6 => 650 }.freeze

        MARKET = [
          %w[50 55 60 65 70p 75p 80p 85p 90p 95p 100p 105 110 115 120 126 192 198 144
             151 158 172 180 188 196 204 013 222 231 240 250 260 275 290 300],
        ].freeze

        TRAIN_FOR_PLAYER_COUNT = {
          2 => { '2': 5, '3': 4, '4': 2, '5': 3, '6': 3, '8': 4, '2n': 7, '3n': 5, '4n': 4, '5n': 5 },
          3 => { '2': 7, '3': 5, '4': 3, '5': 3, '6': 3, '8': 6, '2n': 5, '3n': 5, '4n': 3, '5n': 4 },
          4 => { '2': 9, '3': 7, '4': 4, '5': 3, '6': 3, '8': 8, '2n': 7, '3n': 6, '4n': 4, '5n': 5 },
          5 => { '2': 10, '3': 8, '4': 5, '5': 3, '6': 3, '8': 10, '2n': 9, '3n': 7, '4n': 5, '5n': 6 },
          6 => { '2': 10, '3': 9, '4': 5, '5': 3, '6': 3, '8': 12, '2n': 10, '3n': 8, '4n': 6, '5n': 7 },
        }.freeze

        PHASES = [{ name: '2', train_limit: 4, tiles: [:yellow], operating_rounds: 1 },
                  {
                    name: '3',
                    on: '3',
                    train_limit: 4,
                    tiles: %i[yellow green],
                    operating_rounds: 2,
                  },
                  {
                    name: '4',
                    on: '4',
                    train_limit: 3,
                    tiles: %i[yellow green],
                    operating_rounds: 2,
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
                    name: '8',
                    on: '8',
                    train_limit: 2,
                    tiles: %i[yellow green brown gray],
                    operating_rounds: 3,
                  }].freeze

        TRAINS = [{ name: '2', distance: 2, price: 100, rusts_on: '4' },
                  {
                    name: '3',
                    distance: 3,
                    price: 200,
                    rusts_on: '6',
                    variants: [
                      {
                        name: '3+',
                        distance: 3,
                        price: 230,
                      },
                    ],
                  },
                  {
                    name: '4',
                    distance: 4,
                    price: 300,
                    rusts_on: '8',
                    variants: [
                      {
                        name: '4+',
                        distance: 4,
                        price: 340,
                      },
                    ],
                    events: [{ 'type' => 'fec' }],
                  },
                  {
                    name: '5',
                    distance: 5,
                    price: 500,
                    variants: [
                      {
                        name: '5+',
                        distance: 5,
                        price: 550,
                      },
                    ],
                  },
                  {
                    name: '6',
                    distance: 6,
                    price: 600,
                    variants: [
                      {
                        name: '6+',
                        distance: 6,
                        price: 660,
                      },
                    ],
                  },
                  {
                    name: '8',
                    distance: 8,
                    price: 700,
                    variants: [
                      {
                        name: '4D',
                        distance: 4,
                        price: 800,
                      },
                    ],
                  },
                  { name: '2n', distance: 2, price: 80, rusts_on: '4', available_on: '2', track: :narrow },
                  { name: '3n', distance: 3, price: 160, rusts_on: '6', available_on: '2', track: :narrow  },
                  { name: '4n', distance: 4, price: 260, rusts_on: '8', available_on: '2', track: :narrow  },
                  { name: '5n', distance: 5, price: 380, available_on: '2', track: :narrow }]
.freeze
        EVENTS_TEXT = Base::EVENTS_TEXT.merge(
          'fec' => ['FEC is available', '']
        )

        def operating_round(round_num)
          Engine::Round::Operating.new(self, [
            Engine::Step::Bankrupt,
            Engine::Step::SpecialTrack,
            Engine::Step::SpecialToken,
            G18Cuba::Step::HomeToken,
            Engine::Step::IssueShares,
            G18Cuba::Step::Track,
            Engine::Step::Token,
            Engine::Step::Route,
            Engine::Step::Dividend,
            Engine::Step::DiscardTrain,
            G18Cuba::Step::BuyTrain,
          ], round_num: round_num)
        end

        def stock_round
          Round::Stock.new(self, [
            Engine::Step::DiscardTrain,
            Engine::Step::Exchange,
            Engine::Step::SpecialTrack,
            G18Cuba::Step::BuySellParShares,
          ])
        end

        def new_auction_round
          Engine::Round::Auction.new(self, [
            G18Cuba::Step::SelectionAuction,
          ])
        end

        def new_draft_round
          Engine::Round::Draft.new(self, [G18Cuba::Step::SimpleDraft], reverse_order: false)
        end

        def init_stock_market
          StockMarket.new(self.class::MARKET, [], zigzag: :flip)
        end

        def next_round!
          @round =
            case @round
            when Round::Draft
              new_stock_round
            when Round::Stock
              close_unopened_minors if @turn == 1 && @round.round_num == 1
              @operating_rounds = @phase.operating_rounds
              reorder_players
              new_operating_round
            when Round::Operating
              if @round.round_num < @operating_rounds
                or_round_finished
                new_operating_round(@round.round_num + 1)
              else
                @turn += 1
                or_round_finished
                or_set_finished
                new_stock_round
              end
            when init_round.class
              init_round_finished
              reorder_players(:least_cash, log_player_order: true)
              new_draft_round
            end
        end

        def num_trains(train)
          num_players = [@players.size, 2].max
          TRAIN_FOR_PLAYER_COUNT[num_players][train[:name].to_sym]
        end

        def company_header(company)
          company.id[0] == self.class::COMPANY_CONCESSION_PREFIX ? 'CONCESSION' : 'COMMISSIONER'
        end

        def commissioners
          @commissioners ||= @companies.select { |c| c.id[0] == self.class::COMPANY_COMMISIONER_PREFIX }
        end

        def concessions
          @concessions ||= @companies.select { |c| c.id[0] == self.class::COMPANY_CONCESSION_PREFIX }
        end

        def concession?(entity)
          return false unless entity.company?

          concessions.include?(entity)
        end

        def setup
          super
          @corporations, @fec = @corporations.partition { |corporation| corporation.name != 'FEC' }
          @tile_groups = init_tile_groups
          initialize_tile_opposites!
          @unused_tiles = []

          @corporations.each do |c|
            next if c.type == :minor

            c.tokens.last(2).each { |t| t.used = true }
          end

          @minor_graph = Graph.new(self, skip_track: :broad)
        end

        def operating_order
          minors, majors = @corporations.select(&:floated?).partition { |c| c.type == :minor }
          minors.sort_by! do |c|
            sp = c.share_price
            [sp.price, sp.corporations.find_index(c)]
          end
          majors.sort!
          minors + majors
        end

        def close_unopened_minors
          @corporations.each { |c| c.close! if c.type == :minor && !c.floated? }
          @log << 'Unopened minors close'
        end

        def init_tile_groups
          self.class::TILE_GROUPS
        end

        def event_fec!
          @corporations.concat(@fec)
        end

        def graph_for_entity(entity)
          entity.type == :minor ? @minor_graph : @graph
        end

        def upgrade_cost(tile, hex, entity, spender)
          return 0 if entity.type == :minor

          super
        end

        def upgrades_to_correct_city_town?(from, to)
          if from.towns.size == 1 &&
            from.color == :white &&
            to.paths.none? { |p| p.track == :narrow } &&
            to.city_towns.size.zero?
            return true
          end

          super
        end

        def can_par?(corporation, entity)
          return false if corporation.name == 'FC'
          return super unless corporation.type == :minor

          entity.companies.intersect?(concessions)
        end

        def init_company_abilities
          super
        end

        def ipo_name(entity)
          return entity.floated? ? 'Treasury' : 'IPO' if entity.type == :minor

          entity.operated? ? 'Treasury' : 'IPO'
        end

        def home_token_locations(corporation)
          if corporation.type == :minor
            hexes.select { |hex| !hex.tile.label && !hex.tile.cities.empty? }
          elsif corporation.name == 'FEC'
            hexes.select do |hex|
              hex.tile.cities.any? { |city| city.tokenable?(corporation, free: true) }
            end
          end
        end

        def issuable_shares(entity)
          return [] unless entity.corporation?
          return [] unless round.steps.find { |step| step.instance_of?(Engine::Step::IssueShares) }.active?

          bundles_for_corporation(entity, entity).reject { |bundle| bundle.num_shares > 1 }
        end

        def redeemable_shares(entity)
          return [] unless entity.corporation?
          return [] unless round.steps.find { |step| step.instance_of?(Engine::Step::IssueShares) }.active?

          share_price = stock_market.find_share_price(entity, :right).price

          bundles_for_corporation(share_pool, entity)
            .each { |bundle| bundle.share_price = share_price }
            .reject { |bundle| entity.cash < bundle.price }
        end

        def skip_route_track_type(train)
          train.track == :broad ? :narrow : :broad
        end
      end
    end
  end
end
