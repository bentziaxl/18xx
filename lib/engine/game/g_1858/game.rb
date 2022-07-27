# frozen_string_literal: true

require_relative 'meta'
require_relative '../base'

module Engine
  module Game
    module G1858
      class Game < Game::Base
        include_meta(G1858::Meta)

        CURRENCY_FORMAT_STR = '%dP'

        BANK_CASH = 12_000

        CERT_LIMIT = { 3 => 21, 4 => 16, 5 => 13, 6 => 11 }.freeze

        STARTING_CASH = { 3 => 500, 4 => 375, 5 => 300, 6 => 250 }.freeze

        TILES = {
          '1' => 2,
          '2' => 2,
          '3' => 5,
          '4' => 11,
          '5' => 3,
          '6' => 6,
          '7' => 4,
          '8' => 17,
          '9' => 17,
          '55' => 1,
          '56' => 1,
          '57' => 4,
          '58' => 13,
          '69' => 1,
          '71' => {
            'count' => 1,
            'color' => 'yellow',
            'code' => 'town=revenue:10;town=revenue:10;path=a:0,b:_0,track:narrow;
                        path=a:_1,b:_0,track:narrow;path=a:4,b:_1,track:narrow',
          },
          '72' => 2,
          '73' => 4,
          '74' => 4,
          '75' => 2,
          '76' => 2,
          '77' => 2,
          '78' => 6,
          '79' => 6,
          '201' => 6,
          '202' => 2,
          '621' => 2,
          '630' => 1,
          '631' => 1,
          # 'A1' => 1,
          # 'A2' => 1,
          # 'A3' => 1,

        }.freeze

        LOCATION_NAMES = {
          'A14' => 'Lisboa',
          'B5' => 'Vigo',
          'B7' => 'Braga',
          'B9' => 'Porto',
          'B11' => 'Coimbra',
          'B13' => 'Santarem',
          'B15' => 'Setubal',
          'C2' => 'Corunna',
          'C4' => 'Santiago & Orense',
          'C20' => 'Faro',
          'D3' => 'Lugo',
          'D13' => 'Cacares',
          'D15' => 'Badajoz',
          'D19' => 'Huevia',
          'E18' => 'Seville',
          'E20' => 'Cadiz',
          'F1' => 'Gijon',
          'F5' => 'Leon',
          'F9' => 'Salamanca',
          'F19' => 'Marchena',
          'G6' => 'Palencia',
          'G8' => 'Valladolid',
          'G12' => 'Talavera',
          'G18' => 'Cordoba',
          'G20' => 'Malaga',
          'H3' => 'Santander',
          'H5' => 'Burgos',
          'H11' => 'Madrid',
          'H13' => 'Aranjuez',
          'H15' => 'Ciudad Real',
          'H17' => 'Linares & Jean',
          'H19' => 'Granda',
          'I2' => 'Bilbao',
          'I4' => 'Vitoria',
          'I10' => 'Guadalajara',
          'J3' => 'San Sebestian',
          'J5' => 'Logrono',
          'J15' => 'Albacete',
          'K4' => 'Pampiona',
          'K18' => 'Murica',
          'L3' => 'France',
          'L7' => 'Zaragoza',
          'L13' => 'Valencia',
          'L17' => 'Alicante',
          'L19' => 'Caragena',
          'M10' => 'Tortosa',
          'M12' => 'Castellon',
          'N7' => 'Lerida',
          'N9' => 'Reus & Tarragona',
          'O8' => 'Barcelona',
          'P7' => 'Gerona',

        }.freeze

        MARKET = [
          %w[0c
             50
             60
             65
             70p
             80p
             90p
             100
             110
             120
             135
             150
             165
             180
             200
             220
             245
             270
             300],

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

        TRAINS = [{ name: '2', distance: 2, price: 80, rusts_on: '4', num: 6 },
                  { name: '3', distance: 3, price: 180, rusts_on: '6', num: 5 },
                  { name: '4', distance: 4, price: 300, rusts_on: 'D', num: 4 },
                  {
                    name: '5',
                    distance: 5,
                    price: 450,
                    num: 3,
                    events: [{ 'type' => 'close_companies' }],
                  },
                  { name: '6', distance: 6, price: 630, num: 2 },
                  {
                    name: 'D',
                    distance: 999,
                    price: 1100,
                    num: 20,
                    available_on: '6',
                    discount: { '4' => 300, '5' => 300, '6' => 300 },
                  }].freeze

        COMPANIES = [
          {
            name: 'Schuylkill Valley',
            sym: 'SV',
            value: 20,
            revenue: 5,
            desc: 'No special abilities. Blocks G15 while owned by a player.',
            abilities: [{ type: 'blocks_hexes', owner_type: 'player', hexes: ['G15'] }],
            color: nil,
          },
          {
            name: 'Champlain & St.Lawrence',
            sym: 'CS',
            value: 40,
            revenue: 10,
            desc: "A corporation owning the CS may lay a tile on the CS's hex even if this hex is not connected"\
                  " to the corporation's track. This free tile placement is in addition to the corporation's normal tile"\
                  ' placement. Blocks B20 while owned by a player.',
            abilities: [{ type: 'blocks_hexes', owner_type: 'player', hexes: ['B20'] },
                        {
                          type: 'tile_lay',
                          owner_type: 'corporation',
                          hexes: ['B20'],
                          tiles: %w[3 4 58],
                          when: 'owning_corp_or_turn',
                          count: 1,
                        }],
            color: nil,
          },
          {
            name: 'Delaware & Hudson',
            sym: 'DH',
            value: 70,
            revenue: 15,
            desc: 'A corporation owning the DH may place a tile and station token in the DH hex F16 for only the $120'\
                  " cost of the mountain. The station does not have to be connected to the remainder of the corporation's"\
                  " route. The tile laid is the owning corporation's"\
                  ' one tile placement for the turn. Blocks F16 while owned by a player.',
            abilities: [{ type: 'blocks_hexes', owner_type: 'player', hexes: ['F16'] },
                        {
                          type: 'teleport',
                          owner_type: 'corporation',
                          tiles: ['57'],
                          hexes: ['F16'],
                        }],
            color: nil,
          },
          {
            name: 'Mohawk & Hudson',
            sym: 'MH',
            value: 110,
            revenue: 20,
            desc: 'A player owning the MH may exchange it for a 10% share of the NYC if they do not already hold 60%'\
                  ' of the NYC and there is NYC stock available in the Bank or the Pool. The exchange may be made during'\
                  " the player's turn of a stock round or between the turns of other players or corporations in either "\
                  'stock or operating rounds. This action closes the MH. Blocks D18 while owned by a player.',
            abilities: [{ type: 'blocks_hexes', owner_type: 'player', hexes: ['D18'] },
                        {
                          type: 'exchange',
                          corporations: ['NYC'],
                          owner_type: 'player',
                          when: 'any',
                          from: %w[ipo market],
                        }],
            color: nil,
          },
          {
            name: 'Camden & Amboy',
            sym: 'CA',
            value: 160,
            revenue: 25,
            desc: 'The initial purchaser of the CA immediately receives a 10% share of PRR stock without further'\
                  ' payment. This action does not close the CA. The PRR corporation will not be running at this point,'\
                  ' but the stock may be retained or sold subject to the ordinary rules of the game.'\
                  ' Blocks H18 while owned by a player.',
            abilities: [{ type: 'blocks_hexes', owner_type: 'player', hexes: ['H18'] },
                        { type: 'shares', shares: 'PRR_1' }],
            color: nil,
          },
          {
            name: 'Baltimore & Ohio',
            sym: 'BO',
            value: 220,
            revenue: 30,
            desc: "The owner of the BO private company immediately receives the President's certificate of the"\
                  ' B&O without further payment. The BO private company may not be sold to any corporation, and does'\
                  ' not exchange hands if the owning player loses the Presidency of the B&O.'\
                  ' When the B&O purchases its first train the private company is closed.'\
                  ' Blocks I13 & I15 while owned by a player.',
            abilities: [{ type: 'blocks_hexes', owner_type: 'player', hexes: %w[I13 I15] },
                        { type: 'close', when: 'bought_train', corporation: 'B&O' },
                        { type: 'no_buy' },
                        { type: 'shares', shares: 'B&O_0' }],
            color: nil,
          },
        ].freeze

        CORPORATIONS = [
          {
            float_percent: 60,
            sym: 'PRR',
            name: 'Pennsylvania Railroad',
            logo: '18_chesapeake/PRR',
            simple_logo: '1830/PRR.alt',
            tokens: [0, 40, 100, 100],
            coordinates: 'H12',
            color: '#32763f',
            reservation_color: nil,
          },
          {
            float_percent: 60,
            sym: 'NYC',
            name: 'New York Central Railroad',
            logo: '1830/NYC',
            simple_logo: '1830/NYC.alt',
            tokens: [0, 40, 100, 100],
            coordinates: 'E19',
            color: :'#474548',
            reservation_color: nil,
          },
          {
            float_percent: 60,
            sym: 'CPR',
            name: 'Canadian Pacific Railroad',
            logo: '1830/CPR',
            simple_logo: '1830/CPR.alt',
            tokens: [0, 40, 100, 100],
            coordinates: 'A19',
            color: '#d1232a',
            reservation_color: nil,
          },
          {
            float_percent: 60,
            sym: 'B&O',
            name: 'Baltimore & Ohio Railroad',
            logo: '18_chesapeake/BO',
            simple_logo: '1830/BO.alt',
            tokens: [0, 40, 100],
            coordinates: 'I15',
            color: '#025aaa',
            reservation_color: nil,
          },
          {
            float_percent: 60,
            sym: 'C&O',
            name: 'Chesapeake & Ohio Railroad',
            logo: '18_chesapeake/CO',
            simple_logo: '1830/CO.alt',
            tokens: [0, 40, 100],
            coordinates: 'F6',
            color: :'#ADD8E6',
            text_color: 'black',
            reservation_color: nil,
          },
          {
            float_percent: 60,
            sym: 'ERIE',
            name: 'Erie Railroad',
            logo: '1846/ERIE',
            simple_logo: '1830/ERIE.alt',
            tokens: [0, 40, 100],
            coordinates: 'E11',
            color: :'#FFF500',
            text_color: 'black',
            reservation_color: nil,
          },
          {
            float_percent: 60,
            sym: 'NYNH',
            name: 'New York, New Haven & Hartford Railroad',
            logo: '1830/NYNH',
            simple_logo: '1830/NYNH.alt',
            tokens: [0, 40],
            coordinates: 'G19',
            city: 0,
            color: :'#d88e39',
            reservation_color: nil,
          },
          {
            float_percent: 60,
            sym: 'B&M',
            name: 'Boston & Maine Railroad',
            logo: '1830/BM',
            simple_logo: '1830/BM.alt',
            tokens: [0, 40],
            coordinates: 'E23',
            color: :'#95c054',
            reservation_color: nil,
          },
        ].freeze

        HEXES = {
          red: {
            %w[K2 N3 O4 P5] =>
                     'offboard=revenue:yellow_30|green_40|brown_50|gray_70;path=a:0,b:_0;path=a:1,b:_0',
            %w[M2] =>
                     'offboard=revenue:yellow_30|green_40|brown_50|gray_70;path=a:0,b:_0',
            %w[L3] =>
                     'offboard=revenue:yellow_30|green_40|brown_50|gray_70;path=a:0,b:_0;path=a:1,b:_0;path=a:5,b:_0',
            # ['I1'] =>
            #        'offboard=revenue:yellow_30|brown_60,hide:1,groups:Gulf;path=a:4,b:_0;border=edge:5',
            # ['J2'] =>
            #        'offboard=revenue:yellow_30|brown_60;path=a:3,b:_0;path=a:4,b:_0;border=edge:2',
            # ['A9'] =>
            #        'offboard=revenue:yellow_30|brown_50,hide:1,groups:Canada;path=a:5,b:_0;border=edge:4',
            # ['A11'] =>
            #        'offboard=revenue:yellow_30|brown_50,groups:Canada;path=a:5,b:_0;path=a:0,b:_0;border=edge:1',
            # ['K13'] => 'offboard=revenue:yellow_30|brown_40;path=a:2,b:_0;path=a:3,b:_0',
            # ['B24'] => 'offboard=revenue:yellow_20|brown_30;path=a:1,b:_0;path=a:0,b:_0',
          },
          gray: {
            ['F1'] => 'city=revenue:40,slots:2;path=a:0,b:_0,track:dual;path=a:1,b:_0,track:dual;path=a:5,b:_0,track:dual',
            ['D1'] => 'path=a:5,b:0,track:dual;path=a:1,b:0,track:dual',
            ['F21'] => 'path=a:2,b:3;path=a:4,b:3',
            %w[H21 K20] => 'path=a:3,b:2',
            ['L17'] => 'town=revenue:10;path=a:1,b:_0;path=a:2,b:_0;path=a:3,b:_0',
            ['L19'] => 'town=revenue:10;path=a:2,b:_0',
          },
          white: {
            %w[C2 I2 B5 H3 H19 G8] => 'city',
            %w[E20 G18 K18] => 'city=revenue:0;upgrade=cost:20,terrain:river',
            %w[E18 G20 L13] => 'city=revenue:0;upgrade=cost:20,terrain:river;label=Y',
            ['O8'] => 'city=revenue:0;label=B',
            ['B9'] => 'city=revenue:0;label=Y;label=P;upgrade=cost:20,terrain:river',
            %w[B7 B11 B15 C20 D3
               D19 F5 F9 G6
               G10 H5 H15 I4 I10 J3 J5
               J15 K4 M12 N7 P7] => 'town',
            %w[H17 N9] => 'town=revenue:0;town=revenue:0',
            %w[A12
               B3
               B17
               B19
               C6
               C10
               C14
               D11
               D17
               E10
               F17
               G4
               G16
               H7
               I12
               J7
               J9
               J11
               J13
               J17
               J19
               K8
               K12
               K14
               K16
               L9
               L15] => 'blank',
            %w[C8 E8 F7 K6 D9 M8
               C12 E12 F13 C18 C16 D15
               E14 F15 G14] =>
               'upgrade=cost:20,terrain:river',

            %w[B13 D13 G12 F19 M10] =>
            'town=revenue:0;upgrade=cost:20,terrain:river',
            %w[E2 E4 E6 E16 G2 D5 D7 I18 M6] =>
            'upgrade=cost:40,terrain:mountain',
            %w[I16 F3 F11 H9 I6 I8 L5 O6 K10 L11] =>
            'upgrade=cost:80,terrain:mountain',
            %w[I20 N5 M4] =>
            'upgrade=cost:120,terrain:mountain',
            ['C4'] => 'town=revenue:0;town=revenue:0;upgrade=cost:40,terrain:mountain',
          },
          yellow: {
            ['H11'] => 'city=revenue:40;city=revenue:40;city=revenue:40;
                        path=a:4,b:_0;path=a:0,b:_0;path=a:1,b:_1;path=a:2,b:_2;label=M',
            ['H13'] => 'town=revenue:10;path=a:3,b:5',
            ['I14'] => 'path=a:2,b:5',
            ['L7'] => 'city=revenue:30,;path=a:1,b:_0;path=a:2,b:_0;path=a:5,b:_0;label=Y;upgrade=cost:20,terrain:river',
          },
          green: {
            ['A14'] => 'city=revenue:40,slots:2;path=a:0,b:_0;path=a:3,b:_0;path=a:4,b:_0;label=L;upgrade=cost:20,terrain:river',
          },
          blue: {
            ['J1'] => 'offboard=revenue:20;path=a:1,b:_0;icon=image:anchor',
            ['A16'] => 'offboard=revenue:30;path=a:3,b:_0;icon=image:anchor',
          },
        }.freeze

        LAYOUT = :flat

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
      end
    end
  end
end
