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

        attr_reader :minors_graph, :can_build_mountain_pass, :north_corp_broad_graph

        attr_accessor :player_debts

        CURRENCY_FORMAT_STR = '₧%d'

        BANK_CASH = 99_999

        CERT_LIMIT = { 3 => 27, 4 => 20, 5 => 16, 6 => 13 }.freeze

        STARTING_CASH = { 3 => 930, 4 => 700, 5 => 560, 6 => 460 }.freeze

        NORTH_CORPS = %w[FdSB FdLR CFEA CFLG].freeze

        SPECIAL_MINORS = %w[MS AC].freeze

        TRACK_RESTRICTION = :permissive

        MOUNTAIN_PASS_ACCESS_HEX = %w[E10 I10 K8 L7].freeze

        MOUNTAIN_PASS_ACCESS_HEX_INCL_SOUTH = %w[E10 I10 K8 L7 D19 E20 F21 G20 H19 I18 J17].freeze

        MOUNTAIN_PASS_HEX = %w[M8 K10 I12 E12 E18 F19 G18 H17 I16].freeze

        MOUNTAIN_PASS_TOKEN_HEXES = %w[M8 K10 I12 E12].freeze

        MOUNTAIN_PASS_TOKEN_COST = { 'M8' => 80, 'K10' => 80, 'I12' => 60, 'E12' => 120 }.freeze

        MOUNTAIN_PASS_TOKEN_BONUS = { 'M8' => 40, 'K10' => 40, 'I12' => 30, 'E12' => 60 }.freeze

        SELL_AFTER = :operate

        SELL_BUY_ORDER = :sell_buy

        NORTH_SOUTH_DIVIDE = 13

        MUST_BUY_TRAIN = :always

        BASE_MINE_BONUS = 10

        BASE_F_TRAIN = 10

        NEXT_SR_PLAYER_ORDER = :least_cash

        DISCARDED_TRAIN_DISCOUNT = 50

        CONTINUOUS_MARKET = true

        BANKRUPTCY_ALLOWED = false

        EBUY_PRES_SWAP = false

        EBUY_DEPOT_TRAIN_MUST_BE_CHEAPEST = false

        GAME_END_CHECK = { final_phase: :one_more_full_or_set }.freeze

        MINOR_TILE_LAYS = [{ lay: true, upgrade: true, cost: 0 }].freeze
        MAJOR_TILE_LAYS = [
          { lay: true, upgrade: true, cost: 0 },
          { lay: true, upgrade: :not_if_upgraded, cost: 20, cannot_reuse_same_hex: true },
        ].freeze
        NORTH_CORP_SOUTH_TILE_LAYS = { lay: true, upgrade: :not_if_upgraded, cost: 20, cannot_reuse_same_hex: true }.freeze

        ABILITY_ICONS = {
          P3: 'strawberry',
        }.freeze

        ASSIGNMENT_TOKENS = {
          'P3' => '/icons/18_esp/strawberry.svg',
        }.freeze

        RENFE_LOGO = '/logos/18_esp/renfe.svg'

        MARKET = [
          %w[50 55 60 65P 70p 75P 80p 85P 90p 95P 100p 115 120p
             126 132 138 144 151 158 165 172 180 188 196 204 213 222 231 240 250 260
             270 280 290 300 310 320 330 340 350 362 375 390 400],
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
          train_limit: { minor: 2, major: 4 },
          tiles: %i[yellow],
          operating_rounds: 1,
          status: %w[can_buy_companies],
        },
                  {
                    name: '3',
                    on: '3',
                    train_limit: { minor: 2, major: 4 },
                    tiles: %i[yellow green],
                    operating_rounds: 2,
                    status: %w[can_buy_companies],
                  },
                  {
                    name: '4',
                    on: '4',
                    train_limit: { minor: 1, major: 3 },
                    tiles: %i[yellow green],
                    operating_rounds: 2,
                    status: ['can_buy_companies'],
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
                    on: '8',
                    train_limit: 2,
                    tiles: %i[yellow green brown gray],
                    operating_rounds: 3,
                  }].freeze

        TRAINS = [

          {
            name: '2',
            distance: 2,
            price: 100,
            num: 12,
            rusts_on: '4',
            variants: [
              {
                name: '1+1',
                distance: [{ 'nodes' => ['town'], 'pay' => 1, 'visit' => 1 },
                           { 'nodes' => %w[city offboard town], 'pay' => 1, 'visit' => 1 }],
                track_type: :narrow,
                no_local: true,
                price: 100,
              },
            ],
          },
          {
            name: '3',
            distance: 3,
            price: 200,
            num: 10,
            rusts_on: '6',
            variants: [
              {
                name: '2+2',
                distance: [{ 'nodes' => ['town'], 'pay' => 2, 'visit' => 2 },
                           { 'nodes' => %w[city offboard town], 'pay' => 2, 'visit' => 2 }],
                track_type: :narrow,
                price: 200,
              },
            ],
            events: [{ 'type' => 'south_majors_available' },
                     { 'type' => 'companies_bought_150' },
                     { 'type' => 'mountain_pass' }],
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
                distance: [{ 'nodes' => ['town'], 'pay' => 3, 'visit' => 3 },
                           { 'nodes' => %w[city offboard town], 'pay' => 3, 'visit' => 3 }],
                track_type: :narrow,
                price: 300,
              },
            ],
            events: [
              { 'type' => 'companies_bought_200' },
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
                distance: [{ 'nodes' => ['town'], 'pay' => 4, 'visit' => 4 },
                           { 'nodes' => %w[city offboard town], 'pay' => 4, 'visit' => 4 }],
                track_type: :narrow,
                price: 500,
              },
            ],
            events: [{ 'type' => 'close_companies' },
                     { 'type' => 'close_minors' }],
          },
          {
            name: '6',
            distance: 6,
            price: 600,
            num: 4,
            variants: [
              {
                name: '5+5',
                distance: [{ 'nodes' => ['town'], 'pay' => 5, 'visit' => 5 },
                           { 'nodes' => %w[city offboard town], 'pay' => 5, 'visit' => 5 }],
                track_type: :narrow,
                price: 600,
              },
            ],
            events: [{ 'type' => 'partial_capitalization' }],
          },

          {
            name: '8',
            distance: 8,
            price: 800,
            num: 30,
            events: [{ 'type' => 'renfe_founded' }],
            variants: [
                      {
                        name: '5+5',
                        distance: [{ 'nodes' => ['town'], 'pay' => 5, 'visit' => 5 },
                                   { 'nodes' => %w[city offboard town], 'pay' => 5, 'visit' => 5 }],
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
                'companies_bought_150' => ['Companies 150%', 'Companies can be bought in for maximum 150% of value'],
                'companies_bought_200' => ['Companies 200%', 'Companies can be bought in for maximum 200% of value'],
                'renfe_founded' => ['RENFE founded'],
                'close_minors' => ['Minors close'],
                'partial_capitalization' => ['Partial Capitalization', 'Corporations launched are partial cap'],
                'mountain_pass' => ['Can build mountain passes']
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

        def init_phase
          G18ESP::Phase.new(game_phases, self)
        end

        def game_phases
          self.class::PHASES
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
            Engine::Step::Assign,
            Engine::Step::Exchange,
            Engine::Step::SpecialToken,
            Engine::Step::BuyCompany,
            G18ESP::Step::HomeToken,
            G18ESP::Step::Mining,
            G18ESP::Step::SpecialTrack,
            G18ESP::Step::Track,
            G18ESP::Step::Route,
            G18ESP::Step::Dividend,
            Engine::Step::DiscardTrain,
            G18ESP::Step::Acquire,
            G18ESP::Step::BuyTrain,
            [Engine::Step::BuyCompany, { blocks: true }],
          ], round_num: round_num)
        end

        def p3
          @p3 ||= company_by_id('P3')
        end

        def p2
          @p2 ||= company_by_id('P2')
        end

        def setup
          @corporations, @future_corporations = @corporations.partition do |corporation|
            corporation.type == :minor || north_corp?(corporation)
          end

          @future_corporations.each { |c| c.shares.last.buyable = false }
          @minors_graph = Graph.new(self, home_as_token: true, ignore_skip_path: true)
          @north_corp_mountain_pass_graph = Graph.new(self)
          @north_corp_broad_graph = Graph.new(self, skip_track: :narrow)

          @company_trains = {}
          @company_trains['P2'] = find_and_remove_train_for_minor

          setup_company_price(1)

          @nationalized_corps = []

          # Initialize the player depts, if player have to take an emergency loan
          @player_debts = Hash.new { |h, k| h[k] = 0 }

          # place tokens on mountain passes

          MOUNTAIN_PASS_TOKEN_HEXES.each do |hex|
            block_token = Token.new(nil, price: 0, logo: '/logos/18_esp/block.svg')
            hex_by_id(hex).tile.cities.first.exchange_token(block_token)
          end
        end

        def init_graph
          Graph.new(self, ignore_skip_path: true)
        end

        def company_header(_company)
          'PIONEER COMPANY'
        end

        def setup_company_price(mulitplier)
          @companies.each { |company| company.max_price = company.value * mulitplier }
        end

        def init_stock_market
          G18ESP::StockMarket.new(game_market, self.class::CERT_LIMIT_TYPES,
                                  multiple_buy_types: self.class::MULTIPLE_BUY_TYPES,
                                  continuous: self.class::CONTINUOUS_MARKET, zigzag: true)
        end

        def init_train_handler
          trains = self.class::TRAINS.flat_map do |train|
            Array.new((train[:num] || num_trains(train))) do |index|
              Train.new(**train, index: index)
            end
          end

          G18ESP::Depot.new(trains, self)
        end

        def operating_order
          @corporations.select { |c| c.floated? && !nationalized?(c) }.sort
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
                and immediately sets its par value. It closes when #{random_corporation.name} buys its first train."
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
          return MINOR_TILE_LAYS if entity.type == :minor || north_corp?(entity)

          MAJOR_TILE_LAYS
        end

        def tile_lays_north_corp_south
          NORTH_CORP_SOUTH_TILE_LAYS
        end

        def north_corp?(entity)
          return false unless entity&.corporation?

          NORTH_CORPS.include? entity.name
        end

        def event_south_majors_available!
          @corporations.concat(@future_corporations)
          @log << '-- Major corporations in the south now available --'
        end

        def event_companies_bought_150!
          setup_company_price(1.5)
        end

        def event_mountain_pass!
          @can_build_mountain_pass = true
        end

        def event_companies_bought_200!
          setup_company_price(2)
        end

        def pajares_broad?
          @pajares_broad ||= @optional_rules.include?(:pajares_broad)
        end

        def event_close_minors!
          @log << '-- Event: Minors close --'
          @corporations.dup.each do |c|
            next unless c

            c.shares.last&.buyable = true
            next unless c.type == :minor

            delete_token_mz(c) if c&.name == 'MZ'
            hex_by_id(c.destination).tile.icons.reject! { |i| i.name == c.name }
            close_corporation(c)
          end
        end

        def event_close_companies!
          @log << '-- Event: Pioneer companies close --'
          @companies.each do |company|
            next if company.sym == 'MEA'
            if (ability = abilities(company, :close, on_phase: 'any')) && (ability.on_phase == 'never' ||
                      @phase.phases.any? { |phase| ability.on_phase == phase[:name] })
              next
            end

            company.close!
          end

          @corporations.each do |corp|
            corp.remove_assignment!('P3') if corp.assigned?('P3')
          end
          hex_by_id('G26').remove_assignment!('P3')
        end

        def event_partial_capitalization!
          @corporations.select(&:floated).each do |c|
            c.goal_reached!(:takeover) unless c.taken_over_minor
          end
          @corporations.each { |c| c.shares.last&.buyable = true unless c.type == :minor }

          @partial_cap = true
        end

        def event_renfe_founded!
          @renfe_formed = true
        end

        # market
        def par_prices(corp)
          par_type = corp.type == 'major' ? %i[par] : %i[par_overlap]
          stock_market.share_prices_with_types(par_type)
        end

        def float_corporation(corporation)
          if @partial_cap
            corporation.capitalization = :incremental
            # release tokens
            corporation.tokens.each { |token| token.used = false if token.used == true && !token.hex }
            # all goals reached, no extra cap
            corporation.destination_connected = true
            corporation.ran_offboard = true
            corporation.ran_southern_map = true
            corporation.taken_over_minor = true
          end
          @log << "#{corporation.name} floats"
          share_count = corporation.type == :major ? 4 : 2

          @bank.spend(corporation.par_price.price * share_count, corporation)
          @log << "#{corporation.name} receives #{format_currency(corporation.cash)}"
        end

        def home_token_can_be_cheater
          true
        end

        def north_hex?(hex)
          hex.y < NORTH_SOUTH_DIVIDE
        end

        def mountain_pass_access?(hex)
          MOUNTAIN_PASS_ACCESS_HEX.include?(hex&.id)
        end

        def mountain_pass_access_incl_south?(hex)
          MOUNTAIN_PASS_ACCESS_HEX_INCL_SOUTH.include?(hex&.id)
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

        def subsidy_for(route, stops)
          return 0 if route.train.name == 'F'

          count = route.all_hexes.count { |hex| MINE_HEXES.include?(hex.name) }
          subsidy = count * BASE_MINE_BONUS

          subsidy += harbor_revenue(route, stops)

          subsidy
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
          start_city_hex = route.train.owner.tokens.first.hex
          start_city_hex ||= hex_by_id(route.train.owner.coordinates)
          (visits.first.hex == mea_hex || visits.first.hex == start_city_hex) &&
          (visits.last.hex == mea_hex || visits.last.hex == start_city_hex)
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
          return false unless entity&.corporation?
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
          routes.any? { |route| route.visited_stops.any? { |visit| visit.offboard? && visit.tile.color == :red } }
        end

        def check_southern_map_goal(entity, routes)
          return false unless entity.corporation?
          return false unless north_corp?(entity)
          return false if entity.type == :minor
          return true if entity.ran_southern_map?

          # logic to check if narrow track train connects to target cities
          routes.any? do |route|
            next unless route.train.track_type == :narrow

            route.visited_stops.any? { |stop| %w[I16 E18].include?(stop.hex.id) }
          end
        end

        def mountain_pass_proposed_track_type(entity)
          return :broad unless north_corp?(entity)

          entity.interchange? ? :dual : :narrow
        end

        def open_mountain_pass(entity, pass_hex)
          pass_tile = hex_by_id(pass_hex).tile
          track_type = mountain_pass_proposed_track_type(entity)
          track_type = track_type_into_mountain_pass(hex_by_id(pass_hex)) if track_type == :dual

          pass_tile.paths.each do |path|
            path.walk { |p| p.track = track_type if p.tile.color == :orange }
          end

          mount_pass_cost = mountain_pass_token_cost(hex_by_id(pass_hex), entity)
          entity.spend(mount_pass_cost, @bank)

          opened_mountain_passes[pass_hex] = track_type
          pass_tile.cities.first.tokens.each(&:remove!)

          @log << "#{entity.name} spends #{format_currency(mount_pass_cost)} to open mountain pass"
        end

        def opening_new_mountain_pass(entity)
          return {} unless entity

          @north_corp_mountain_pass_graph.clear if north_corp?(entity)
          graph = north_corp?(entity) ? @north_corp_mountain_pass_graph : graph_for_entity(entity)
          openable_passes = graph.reachable_hexes(entity).keys.select do |hex|
            mountain_pass_token_hex?(hex)
          end
          openable_passes = openable_passes.reject { |hex| opened_mountain_passes.key?(hex.id) }

          # reject passes if track type is wrong
          openable_passes = openable_passes.reject do |pass_hex|
            track_restriction = track_type_into_mountain_pass(pass_hex)
            next false unless track_restriction

            proposed_track_type = mountain_pass_proposed_track_type(entity)

            next true if pajares_broad? && pass_hex.id == 'E12' && proposed_track_type != :broad

            next false if proposed_track_type == :dual

            proposed_track_type != track_restriction
          end
          return {} if openable_passes.empty? || last_track_type?(entity, openable_passes)

          openable_passes.to_h do |hex|
            [hex.id, "#{hex.location_name} (#{format_currency(mountain_pass_token_cost(hex, entity))})"]
          end
        end

        def graph_skip_paths(_entity)
          @skip_paths ||= {}
          return @skip_paths unless @skip_paths.empty?

          MOUNTAIN_PASS_TOKEN_HEXES.each do |hex_id|
            hex = hex_by_id(hex_id)
            hex.tile.paths.each do |path|
              path.exits.each do |exit|
                neighbor = hex.neighbors[exit]
                ntile = neighbor&.tile
                next false unless ntile&.color == :orange

                @skip_paths[path] = true
                ntile.paths.each { |ntile_path| @skip_paths[ntile_path] = true }
              end
            end
          end
          @skip_paths.empty? ? nil : @skip_paths
        end

        def track_type_into_mountain_pass(hex)
          return unless hex.tile

          npath = hex.tile.paths.map do |path|
            path.exits.map do |exit|
              neighbor = hex.neighbors[exit]
              ntile = neighbor&.tile
              next unless ntile
              next if ntile.color == :orange

              npath = ntile.paths.map { |b| b if path.connects_to?(b, nil) }
              npath.first if npath
            end.compact
          end.compact.flatten

          return unless npath&.first

          npath.first.track
        end

        def last_track_type?(entity, openable_passes)
          return false unless openable_passes.length == 1

          opened_passes_uniq = opened_mountain_passes.values.uniq
          last_pass_different = opened_passes_uniq.length == 1 && opened_mountain_passes.length == 3
          return false unless last_pass_different

          proposed_track_type = mountain_pass_proposed_track_type(entity)
          last_mountain_pass = MOUNTAIN_PASS_TOKEN_HEXES - openable_passes
          proposed_track_type = track_type_into_mountain_pass(last_mountain_pass) if proposed_track_type == :dual

          return false unless opened_passes_uniq.first == proposed_track_type

          @log << 'Last mountain pass must be of a different track type, skipping opening mountain pass'
          true
        end

        def mountain_pass_token_cost(hex, entity)
          base_cost = MOUNTAIN_PASS_TOKEN_COST[hex.id]
          base_cost -= 20 if entity.companies.include?(p5) && hex.id == 'I2'
          base_cost
        end

        def mountain_pass_token_hex?(hex)
          MOUNTAIN_PASS_TOKEN_HEXES.include?(hex.id)
        end

        def visited_stops(route)
          route_stops = super
          route_stops.reject { |stop| mountain_pass_token_hex?(stop.hex) && stop.tokened_by?(route.train.owner) }
        end

        def check_distance(route, visits, train = nil)
          entity = route.corporation
          if route.train.name == 'F' && f_train_correct_route?(route, visits, @round.mea_hex)
            raise GameError, 'Route must connect Mine Tile placed and home token'
          end

          if mountain_pass_token_hex?(route.hexes.first) || mountain_pass_token_hex?(route.hexes.last)
            raise GameError,
                  'Route can not end or start in Mountain pass'
          end

          if entity.type == :minor && visits.any?(&:offboard?)
            raise GameError,
                  'Minors can not run to offboard locations'
          end

          if route.train.name != 'F' && (visits.first&.halt? || visits.last&.halt?)
            raise GameError,
                  'Regular train can not start or end at at a mine tile without a city or town'
          end

          visits = visits.dup.reject(&:halt?) if route.train.name != 'F'

          if mountain_pass_token_hex?(route.hexes.first) || mountain_pass_token_hex?(route.hexes.last)
            raise GameError,
                  'Route can not end or start in Mountain pass'
          end

          raise GameError, 'Route can only use one mountain pass' if route.hexes.count { |hex| mountain_pass_token_hex?(hex) } > 1

          # north corp running broad
          if north_corp?(entity) && route.train.track_type == :broad
            valid_broad = route.stops.any? { |stop| stop.tokened_by?(entity) && valid_interchange?(stop.tile) }
            raise GameError, 'Broad train must include a valid interchange' unless valid_broad
          end

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

        def valid_interchange?(tile)
          uniq_tracks = tile.paths.map(&:track).uniq
          uniq_tracks.include?(:dual) || uniq_tracks.include?(:broad)
        end

        def revenue_for_f(route, stops)
          non_halt_stops = stops.count { |stop| !stop.is_a?(Part::Halt) }
          total_count = non_halt_stops + route.all_hexes.count { |hex| MINE_HEXES.include?(hex.name) }
          total_count * BASE_F_TRAIN
        end

        def revenue_for(route, stops)
          return revenue_for_f(route, stops) if route.train.name == 'F'

          revenue = super
          bonus = route.hexes.sum do |hex|
            tokened_mountain_pass(hex, route.train.owner) ? MOUNTAIN_PASS_TOKEN_BONUS[hex.id] : 0
          end
          revenue += bonus
          revenue += p3_bonus(route, stops) ? 20 : 0
          revenue += east_west_bonus(stops)[:revenue]
          revenue += gbi_bm_bonus(stops)[:revenue]

          revenue -= harbor_revenue(route, stops)

          revenue
        end

        def harbor_revenue(route, stops)
          stops.sum { |stop| stop.tile.color == :blue ? stop.route_revenue(route.phase, route.train) : 0 }
        end

        def p3_bonus(route, stops)
          route.corporation.assigned?('P3') && (assigned_stop = stops.find do |s|
                                                  s.hex.assigned?('P3')
                                                end) && aranjuez?(assigned_stop)
        end

        def aranjuez?(stop)
          stop.paths.any? do |p|
            p.exits.any? do |exit|
              neighbor = stop.hex.neighbors[exit]
              neighbor&.id == 'G24'
            end
          end
        end

        def east_west_bonus(stops)
          bonus = { revenue: 0 }

          east = stops.find { |stop| stop.tile.label&.to_s == 'E' }
          west = stops.find { |stop| stop.tile.label&.to_s == 'W' }

          if east && west
            bonus[:revenue] += 50
            bonus[:description] = 'E/W'
          end

          bonus
        end

        def gbi_bm_bonus(stops)
          bonus = { revenue: 0 }

          bm = stops.find { |stop| %w[M B].include?(stop.tile.label&.to_s) }
          gbi = stops.find { |stop| %w[G Bi].include?(stop.tile.label&.to_s) }

          if bm && gbi
            bonus[:revenue] += 100
            bonus[:description] = 'G/Bi to B/M'
          end

          bonus
        end

        def gbi_bm_interchange_bonus(routes)
          bonus = { revenue: 0 }
          return bonus unless north_corp?(routes.first&.train&.owner)

          leon = routes.select { |r| r.stops.find { |st| st.hex.id == 'E18' } }
          sanseb = routes.select { |r| r.stops.find { |st| st.hex.id == 'I16' } }

          if leon.length > 1
            bonus = gbi_bm_bonus(leon.flat_map(&:stops))
          elsif sanseb.length > 1
            bonus = gbi_bm_bonus(sanseb.flat_map(&:stops))
          end
          bonus
        end

        def tokened_mountain_pass(hex, entity)
          mountain_pass_token_hex?(hex) &&
          hex.tile.stops.first.tokened_by?(entity)
        end

        def revenue_str(route)
          rev_str = super
          rev_str += ' + mountain pass' if route.hexes.any? { |hex| mountain_pass_token_hex?(hex) }
          rev_str += ' + strawberry' if p3_bonus(route, route.stops)

          ewbonus = east_west_bonus(route.stops)[:description]
          rev_str += " + #{ewbonus}" if ewbonus

          bonus = gbi_bm_bonus(route.stops)[:description]
          rev_str += " + #{bonus}" if bonus

          rev_str
        end

        def routes_revenue(routes)
          revenue = super - f_train_revenue(routes)
          bonus = gbi_bm_interchange_bonus(routes)[:revenue]
          revenue += bonus if bonus
          revenue
        end

        def submit_revenue_str(routes, show_subsidy)
          rev_str = super

          bonus = gbi_bm_interchange_bonus(routes)[:description]
          rev_str += " + #{bonus}" if bonus
          rev_str
        end

        def f_train_revenue(routes)
          routes.find { |r| r.train.name == 'F' }&.revenue || 0
        end

        def route_distance_str(route)
          towns = route.visited_stops.count { |visit| mountain_pass_token_hex?(visit.hex) ? 1 : (visit.town? && !visit.halt?) }
          halts = route.visited_stops.count(&:halt?)
          cities = route_distance(route) - towns
          cities = route.train.name == 'F' ? cities : cities - halts
          towns.positive? ? "#{cities}+#{towns}" : cities.to_s
        end

        def start_merge(corporation, minor, keep_token)
          # take over assets
          move_assets(corporation, minor)

          # handle token
          keep_token ? swap_token(corporation, minor) : gain_token(corporation, minor)

          # complete goal
          corporation.goal_reached!(:takeover)

          # pay compensation
          pay_compensation(corporation, minor)

          # get share
          get_reserved_share(minor.owner, corporation)

          # remvoe destination token
          hex_by_id(minor.destination).tile.icons.reject! { |i| i.name == minor.name }

          # close corp
          close_corporation(minor)
        end

        def pay_compensation(corporation, minor)
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
          delete_token_mz(minor) if minor&.name == 'MZ'
        end

        def delete_token_mz(minor)
          token = minor.tokens.first
          return unless token.used

          city = token.city
          # check if there's another slot
          delete_slot = city.slots > 1
          # check if slot is already used, if not reserve
          corp = @corporations.find { |c| c.city == city.index }

          city.delete_token!(token, remove_slot: delete_slot)
          city.add_reservation!(corp) unless delete_slot
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
            survivor.companies << c
          end

          # code to move strawberry token
          survivor.assign!('P3') if nonsurvivor.assignments.any? { |a, _| a == 'P3' }
          nonsurvivor.companies.clear

          @log << "Moved assets from #{nonsurvivor.name} to #{survivor.name}"
        end

        def must_buy_train?(entity)
          trains = entity.trains
          trains = trains.dup.reject { |t| t.track_type == :narrow } if !north_corp?(entity) || entity.type == :minor
          trains = trains.dup.reject { |t| t.track_type == :broad } if north_corp?(entity) && !entity.interchange?
          trains.empty? && !depot.depot_trains.empty?
        end

        def place_home_token(corporation)
          return if special_minor?(corporation)

          return unless corporation.next_token # 1882
          # If a corp has laid it's first token assume it's their home token
          return if corporation.tokens.first&.used

          hex = hex_by_id(corporation.coordinates)

          tile = hex&.tile
          if !tile || (tile.reserved_by?(corporation) && tile.paths.any?)

            if @round.pending_tokens.any? { |p| p[:entity] == corporation }
              # 1867: Avoid adding the same token twice
              @round.clear_cache!
              return
            end

            # If the tile does not have any paths at the present time, clear up the ambiguity when the tile is laid
            # otherwise the entity must choose now.
            hexes =
              if hex
                [hex]
              else
                home_token_locations(corporation)
              end

            return unless hexes

            @log << "#{corporation.name} must choose city for home token"
            @round.pending_tokens << {
              entity: corporation,
              hexes: hexes,
              token: corporation.find_token_by_type,
            }

            @round.clear_cache!
            return
          end

          cities = tile.cities

          city = cities.find { |c| c.reserved_by?(corporation) || c.index == corporation.city } || cities.first
          token = corporation.find_token_by_type

          if city.tokenable?(corporation, tokens: token)
            @log << "#{corporation.name} places a token on #{hex.name}"
            city.place_token(corporation, token)
          elsif home_token_can_be_cheater
            @log << "#{corporation.name} places a token on #{hex.name}"
            city.place_token(corporation, token, cheater: true)
          end

          corporation.goal_reached!(:destination) if check_for_destination_connection(corporation)
        end

        def graph_for_entity(entity)
          special_minor?(entity) ? @minors_graph : @graph
        end

        def special_minor?(entity)
          return false unless entity.corporation?

          SPECIAL_MINORS.include?(entity.name)
        end

        def check_route_token(route, token)
          return super unless special_minor?(route.corporation)

          home_hex = hex_by_id(route.corporation.coordinates)

          raise NoToken, 'Route must contain home hex' unless route.hexes.include?(home_hex)
        end

        def rust_trains!(train, _entity)
          reserved_2t = train_by_id('2-0')
          return super unless reserved_2t

          @depot.reclaim_train(reserved_2t) if rust?(reserved_2t, train)
          super
        end

        def find_and_remove_train_for_minor
          train = train_by_id('2-0')
          @depot.remove_train(train)
          train.buyable = true
          train.reserved = true
          train
        end

        def company_bought(company, entity)
          # On acquired abilities
          on_acquired_train(company, entity) if company.id == 'P2'
        end

        def on_acquired_train(company, entity)
          train = @company_trains[company.id]
          return if train.rusted

          if entity.trains.size < train_limit(entity)
            buy_train(entity, train, :free)
            @log << "#{entity.name} gains a #{train.name} train"
          end
          train.operated = true
          @company_trains.delete(company.id)
        end

        # OR has just finished, find two lowest revenues and nationalize the corporations
        # associated with each
        def nationalize_corps!
          revenues = @corporations.select { |c| c.floated? && !nationalized?(c) && !north_corp?(c) }
            .to_h { |c| [c, get_or_revenue(c.operating_history[c.operating_history.keys.max])] }

          sorted_corps = revenues.keys.sort_by { |c| revenues[c] }

          if sorted_corps.size < 3
            # if two or less corps left, they are both nationalized
            sorted_corps.each { |c| make_nationalized!(c) }
          else
            # all companies with the lowest revenue are nationalized
            # if only one has the lowest revenue, then all companies with the next lowest revenue are nationalized
            min_revenue = revenues[sorted_corps[0]]
            next_revenue_corp = sorted_corps.find { |c| revenues[c] > min_revenue }
            next_revenue = revenues[next_revenue_corp] if next_revenue_corp

            grouped = revenues.keys.group_by { |c| revenues[c] }
            grouped[min_revenue].each { |c| make_nationalized!(c) }
            grouped[next_revenue].each { |c| make_nationalized!(c) } if next_revenue_corp && grouped[min_revenue].one?
          end
        end

        def make_nationalized!(corp)
          return if nationalized?(corp)

          corp.tokens.each { |t| t.logo = RENFE_LOGO }
          corp.tokens.each { |t| t.simple_logo = RENFE_LOGO }

          @nationalized_corps << corp
          @log << "#{corp.name} is Nationalized and will cease to operate."
          pay_nationalization_compensation(corp)
        end

        def nationalized?(corp)
          @nationalized_corps.include?(corp)
        end

        def pay_nationalization_compensation(corporation)
          per_share = @stock_market.find_share_price(corporation, :right).price
          payouts = {}
          @players.each do |player|
            amount = player.num_shares_of(corporation) * per_share
            next if amount.zero?

            payouts[player] = amount
            @bank.spend(amount, player, check_cash: false, borrow_from: corporation.owner)
          end

          return if payouts.empty?

          receivers = payouts
                        .sort_by { |_r, c| -c }
                        .map { |receiver, cash| "#{format_currency(cash)} to #{receiver.name}" }.join(', ')

          @log << "Shareholders of #{corporation.name} receive compensation "\
                  "#{format_currency(per_share)} per share (#{receivers})"
        end

        def get_or_revenue(info)
          !info.dividend.is_a?(Action::Dividend) || info.dividend.kind == 'withhold' ? 0 : info.revenue
        end

        def next_round!
          return super unless final_ors?

          nationalize_corps!
          super
        end

        def or_set_finished
          @depot.export! if @corporations.any?(&:floated?)
          game_end_check

          @corporations = @corporations.dup.select(&:floated?) if @turn == @final_turn
        end

        def final_ors?
          @turn == @final_turn && @round.is_a?(Round::Operating)
        end

        def holder_for_corporation(_entity)
          # Incremental corps DON'T get paid from IPO shares.
          @game.share_pool
        end

        def next_sr_player_order
          @round_counter.zero? ? :least_cash : :most_cash
        end

        def can_hold_above_corp_limit?(_entity)
          true
        end

        def player_debt(player)
          @player_debts[player] || 0
        end

        def take_player_loan(player, loan)
          # Give the player the money.from the bank
          @bank.spend(loan, player)

          # Add interest to the loan, must atleast pay 150% of the loaned value
          @player_debts[player] += loan
        end

        def payoff_player_loan(player)
          # Pay full or partial of the player loan. The money from loans is outside money, doesnt count towards
          # the normal bank money.
          if player.cash >= @player_debts[player]
            player.spend(@player_debts[player], @bank)
            @log << "#{player.name} pays off their loan of #{format_currency(@player_debts[player])}"
            @player_debts[player] = 0
          else
            principal_raw = (player.cash / 1.2).floor
            principal = (principal_raw / 10).floor * 10
            interest = principal * 0.2
            payment = principal + interest
            @player_debts[player] -= payment
            @log << "#{player.name} pays #{format_currency(payment)}. Loan decreases by #{format_currency(principal)}. "\
                    "#{player.name} pays #{format_currency(interest)} in interest"
            player.spend(payment, @bank)
          end
        end

        def player_value(player)
          player.value - @player_debts[player]
        end

        def add_interest_player_loans!
          @player_debts.each do |player, loan|
            next unless loan.positive?

            interest = loan * 0.5
            new_loan = loan + interest
            @player_debts[player] = new_loan
            @log << "#{player.name} increases their loan by 50% (#{format_currency(interest)}) to "\
                    "#{format_currency(new_loan)}"
          end
        end

        def remove_dest_icon(corp)
          tile = hex_by_id(corp.destination).tile
          tile.icons = tile.icons.dup.reject { |icon| icon.name == corp.name }
        end

        def render_halts?
          false
        end

        def fix_mine_token(city)
          return unless mountain_pass_token_hex?(city.hex)

          city.tokens.first.type = :neutral
        end

        def train_help(entity, runnable_trains, _routes)
          help = []

          f_train = runnable_trains.any? { |t| t.name == 'F' }

          help << 'Plus trains (N+N) run on narrow track. Regular trains run on iberian track.'
          help << if north_corp?(entity)
                    "#{entity.name} can own at most one iberian track train. If it has a valid tokened interchange" \
                      ' it can run a regular train and count it as an owned train.' \
                      "Otherwise a regular train doesn't count as an owned train"
                  else
                    "#{entity.name} can own at most one narrow track train. The train doesn't count as an owned train"
                  end
          if f_train
            help << 'F trains run from the mine tile laid this OR to the home token, ' \
                    'counting +10 for every town, city and mine passed. Revenue is split 50-50'
          end

          help
        end
      end
    end
  end
end
