# frozen_string_literal: true

module Engine
  module Game
    module G18ESP
      module Entities
        # companies found only in 1st Edition
        COMPANIES = [
          {
            sym: 'IMC',
            name: 'Idarado Mining Company',
            value: 30,
            revenue: 5,
            desc: 'Money gained from mine tokens is doubled for the owning Corporation. '\
                  'If owned by a Corporation, closes on purchase of “6” train, otherwise '\
                  'closes on purchase of “5” train.',
            abilities: [{ type: 'close', owner_type: 'corporation', on_phase: '6' }],
            color: nil,
          },
          {
            sym: 'GJGR',
            name: 'Grand Junction and Grand River Valley Railway',
            value: 40,
            revenue: 10,
            desc: 'An owning Corporation may upgrade a yellow town to a green city in '\
                  'additional to its normal tile lay at any time during its turn. This tile '\
                  'does not need to be reachable by the corporation\'s trains. Action closes '\
                  'the company or closes on purchase of “5” train.',
            color: nil,
          },
          {
            sym: 'DNP',
            name: 'Denver, Northwestern and Pacific Railroad',
            value: 50,
            revenue: 10,
            desc: 'An owning Corporation may return a station token to its charter to gain '\
                  'the token cost. The token is placed on the rightmost (most expensive) empty '\
                  'token slot with money gained corresponding to empty token slot\'s price. The '\
                  'corporation must always have at least one token on the board. Action closes '\
                  'the company or closes on purchase of “5” train.',
            color: nil,
          },
          {
            sym: 'Toll',
            name: 'Saguache & San Juan Toll Road Company',
            value: 60,
            revenue: 10,
            desc: 'An owning Corporation receives a $20 discount on the cost of tile lays. Closes '\
                  'on purchase of “5” train.',
            color: nil,
          },
          {
            sym: 'LNPW',
            name: 'Laramie, North Park and Western Railroad',
            value: 70,
            revenue: 15,
            desc: 'When laying track tiles, an owning Corporation may lay an extra yellow tile at '\
                  'no cost in addition to its normal tile lay. Action closes the company or closes '\
                  'on purchase of “5” train.',
            color: nil,
          },
          {
            sym: 'DPRT',
            name: 'Denver Pacific Railway and Telegraph Company',
            value: 100,
            revenue: 15,
            desc: 'The owner immediately receives one share of either Denver Pacific Railroad, '\
                  'Colorado and Southern Railroad, Kansas Pacific Railway or Colorado Midland Railway. '\
                  'The railroad receives money equal to the par value when the President’s Certificate '\
                  'is purchased. Closes on purchase of “5” train.',
            color: nil,
          },
          {
            sym: 'DRGR',
            name: 'Denver & Rio Grande Railway Silverton Branch',
            value: 120,
            revenue: 25,
            desc: 'The owner receives the Presidency of Durango and Silverton Narrow Gauge, which '\
                  'floats immediately. Closes when the DSNG runs a train or on purchase of “5” train. '\
                  'Cannot be purchased by a Corporation. Does not count towards net worth.',
            color: nil,
          },
        ].freeze

        # corporations with different properties in 1st Edition
        CORPORATIONS = [
          {
            float_percent: 50,
            float_excludes_market: true,
            sym: 'SX',
            name: 'Sächsische Eisenbahn',
            logo: '18_cz/SX',
            simple_logo: '18_cz/SX.alt',
            max_ownership_percent: 60,
            always_market_price: true,
            tokens: [0, 40],
            color: :'#e31e24',
            type: 'large',
            reservation_color: nil,
          },
        ].freeze
      end
    end
  end
end
