# frozen_string_literal: true

module Engine
  module Game
    module G18ESP
      module Entities
        COMPANIES = [
          {
            sym: 'P1',
            name: 'Ferrocarril de La Habana a Güines',
            value: 50,
            revenue: 20,
            desc: 'No special abilities.',
            color: nil,
          },
          {
            sym: 'P2',
            name: 'Ferrocarril de Madrid a Aranjuez o El tren de la fresa',
            value: 70,
            revenue: 15,
            desc: 'Owning Corporation may place a Strawberry token in Aranjuez to add 20 to all routes it runs to this location',
            color: nil,
          },
          {
            sym: 'P3',
            name: 'Ferrocarril de Murcia a Cartagena',
            value: 100,
            revenue: 20,
            desc: 'Comes with 1 Mining Exploitation Authorization (MEA) license. Using the MEA does not close the company.',
            color: nil,
          },
          {
            sym: 'P4',
            name: 'Ferrocarril de Barcelona a Mataró',
            value: 120,
            revenue: 20,
            desc: 'Owning Corporation receives 2H train. The train can not run in the same OR this company is purchased',
            color: nil,
          },
          {
            sym: 'P5',
            name: 'Ferrocarril de Alar del Rey a Santander',
            value: 160,
            revenue: 15,
            desc: '10% share of El Ferrocarril de La Robla',
            color: nil,
          },
          {
            sym: 'P6',
            name: 'Ferrocarril de Carreño',
            value: 180,
            revenue: 30,
            desc: 'President share of one Northern major company (randomly selected before the game starts). It closes when the major company buys its first train.',
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
