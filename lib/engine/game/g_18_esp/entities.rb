# frozen_string_literal: true

module Engine
  module Game
    module G18ESP
      module Entities
        MINE_HEXES = %w[C5 C9 E9 E11 E19 G9 H6 I7 C23 G21 D18 D32 E31 H30 I23 D8 E7 B30 F30 F32 I21].freeze
        COMPANIES = [
          {
            sym: 'P1',
            name: 'Ferrocarril de La Habana a Güines',
            value: 10,
            revenue: 5,
            min_price: 1,
            desc: 'It gives a discount of pts30 for laying a yellow
            mine tile. When this privilege is done, the
            company closes.',
            abilities: [
              {
                type: 'tile_lay',
                hexes: MINE_HEXES,
                tiles: %w[L89 L90 L91 L92 L93 L94 L95 L96 L98 L99 L100],
                free: false,
                when: 'track',
                discount: 30,
                reachable: true,
                closed_when_used_up: true,
                owner_type: 'corporation',
                count: 1,
              },
            ],
            color: nil,
          },
          {
            sym: 'P2',
            name: 'Ferrocarril de Barcelona a Mataró',
            value: 40,
            revenue: 10,
            min_price: 1,
            desc: 'Owning Corporation receives 2/1+2 train. closes when bought by a corporation.',
            color: nil,
          },
          {
            sym: 'P3',
            name: 'Ferrocarril de Madrid a Aranjuez o El tren de la fresa',
            value: 70,
            revenue: 15,
            min_price: 1,
            desc: 'If owned by a corporation at phase 5 then it is converted to a permanent 2 train. '\
                  'The train does not count towards train limit.  It does not fulfill train ownership requierments'\
                  '. The first run must go through Aranjuez, later runs can be anywhere on the map.',

            color: nil,
          },
          {
            sym: 'P4',
            name: 'Ferrocarril de Valencia a Játiva',
            value: 100,
            revenue: 20,
            min_price: 1,
            desc: 'Owning corporation can upgrade one train per OR and attach a luxury carriage. '\
                  "Luxury carriages provide one more town or mine to the train's range. "\
                  'Can only be attached to iberian gauge trains. The company closes when bought by a corporation.',
            abilities: [
                      {
                        type: 'base',
                        owner_type: 'corporation',
                        description: 'Luxury Carriage',
                        desc_detail: 'Private allows to attach Luxury crriage to regular trains '\
                                     'extending their distance by one town.',
                        when: 'owning_corp_or_turn',
                      },
                    ],
            color: nil,
          },
          {
            sym: 'P5',
            name: 'Ferrocarril de Alar del Rey a Santander',
            value: 130,
            revenue: 25,
            min_price: 1,
            desc: 'he company that owns this pioneer company can place a special harbor tile '\
                  '(fixed value of pts30 in all phases) in hex G3 or I3.  The director of the company decides the '\
                  'direction of the arrow (section of track) on the tile: towards Ribadesella, '\
                  'Llanes o Torrelavega (G3) or towards Santander, Torrelavega or Laredo (I3). '\
                  'At the moment the special tile is laid, the pioneering company closes'\
                  '. If this special tile has not been placed at the start of phase 5, '\
                  'the special tile is removed from the game.',
            abilities: [
                    {
                      type: 'tile_lay',
                      hexes: %w[G3 I3],
                      tiles: ['L133'],
                      owner_type: 'corporation',
                      when: 'owning_corp_or_turn',
                      closed_when_used_up: true,
                      special: true,
                      count: 1,
                      free: true,
                    },
                  ],

          },
          {
            sym: 'P6',
            name: 'Ferrocarril de Carreño',
            value: 160,
            revenue: 30,
            desc: 'President share of one Northern major company (randomly selected before the game starts).'\
                  'It closes when the major company buys its first train.',
            color: nil,
            abilities: [{ type: 'shares', shares: 'random_president' }, { type: 'no_buy' }],
          },
        ].freeze

        # corporations with different properties in 1st Edition
        CORPORATIONS = [
          {
            float_percent: 40,
            sym: 'N',
            name: 'Compañía de los Caminos de Hierro del Norte de España',
            logo: '18_esp/N',
            coordinates: 'F24',
            city: 1,
            max_ownership_percent: 60,
            tokens: [0, 50, 50, 50, 50, 100],
            color: '#C29137',
            type: 'major',
            destination: 'E21',
          },
          {
            float_percent: 40,
            sym: 'MZA',
            name: 'Compañía de los ferrocarriles de Madrid a Zaragoza y Alicante ',
            logo: '18_esp/MZA',
            coordinates: 'F24',
            city: 2,
            max_ownership_percent: 60,
            tokens: [0, 50, 50, 50, 50, 100],
            color: '#FFD526',
            type: 'major',
            destination: 'J28',
          },
          {
            float_percent: 40,
            sym: 'A',
            name: 'Compañía de los Ferrocarriles Andaluces',
            logo: '18_esp/A',
            coordinates: 'E33',
            max_ownership_percent: 60,
            tokens: [0, 50, 50, 50, 50, 100],
            color: '#B75835',
            type: 'major',
            destination: 'C31',
          },
          {
            float_percent: 40,
            sym: 'CRB',
            name: 'Compañía de los Caminos de Hierro de Ciudad Real a Badajoz',
            logo: '18_esp/CRB',
            coordinates: 'B26',
            max_ownership_percent: 60,
            tokens: [0, 50, 50, 50, 50, 100],
            color: '#E96B28',
            type: 'major',
            destination: 'F28',
          },
          {
            float_percent: 40,
            sym: 'MCP',
            name: 'Compañía de los ferrocarriles de Madrid a Cáceres y Portugal',
            logo: '18_esp/MCP',
            coordinates: 'F24',
            city: 0,
            max_ownership_percent: 60,
            tokens: [0, 50, 50, 50, 50, 100],
            color: '#009AD5',
            type: 'major',
            destination: 'C25',
          },

          {
            float_percent: 40,
            sym: 'ZPB',
            name: 'Compañía de los Ferrocarriles de Zaragoza a Pamplona y
            Barcelona',
            logo: '18_esp/ZPB',
            coordinates: 'M21',
            city: 1,
            max_ownership_percent: 60,
            tokens: [0, 50, 50, 50, 50, 100],
            color: '#DA0A26',
            type: 'major',
            destination: 'J20',
          },

          {
            float_percent: 40,
            sym: 'FdSB',
            name: 'Ferrocarril de Santander a Bilbao',
            logo: '18_esp/FdSB',
            coordinates: 'I5',
            max_ownership_percent: 60,
            tokens: [0, 50, 50, 50, 50],
            color: '#009AD5',
            type: 'major',
            destination: 'K5',
          },

          {
            float_percent: 40,
            sym: 'CFEA',
            name: 'Compañía de los Ferrocarriles Económicos de Asturias',
            logo: '18_esp/CFEA',
            coordinates: 'D6',
            city: 1,
            max_ownership_percent: 60,
            tokens: [0, 50, 50, 50, 50],
            color: '#E96B28',
            type: 'major',
            destination: 'G5',
          },

          {
            float_percent: 40,
            sym: 'CFLG',
            name: 'Compañía del Ferrocarril de Langreo en Asturias',
            logo: '18_esp/CFLG',
            coordinates: 'E3',
            max_ownership_percent: 60,
            tokens: [0, 50, 50, 50, 50],
            color: '#DA0A26',
            type: 'major',
            destination: 'E7',
          },

          {
            float_percent: 40,
            sym: 'FdLR',
            name: 'Ferrocarril de La Robla',
            logo: '18_esp/FdLR',
            coordinates: 'H8',
            max_ownership_percent: 60,
            tokens: [0, 50, 50, 50, 50],
            color: '#009141',
            type: 'major',
            destination: 'K5',
          },

          {
            sym: 'MS',
            name: 'Ferrocarril de Mérida a Sevilla',
            logo: '18_esp/MS',
            coordinates: 'C27',
            color: '#7DCCE5',
            tokens: [0],
            type: 'minor',
            shares: [100],
            float_percent: 100,
            max_ownership_percent: 100,
            startable: true,
          },
          {
            sym: 'CM',
            name: 'Compañía del Ferrocarril de Córdoba a Málaga',
            logo: '18_esp/CM',
            coordinates: 'E29',
            color: '#009141',
            tokens: [0],
            type: 'minor',
            shares: [100],
            float_percent: 100,
            max_ownership_percent: 100,
            startable: true,
          },
          {
            sym: 'SC',
            name: 'Compañía del Ferrocarril de Sevilla a Jerez y de Puerto Real a Cádiz',
            logo: '18_esp/SC',
            simple_logo: '18_esp/SC',
            coordinates: 'C31',
            city: 0,
            color: '#FFF014',
            tokens: [0],
            type: 'minor',
            shares: [100],
            float_percent: 100,
            max_ownership_percent: 100,
            startable: true,
          },
          {
            sym: 'AC',
            name: 'Ferrocarril de Albacete a Cartagena',
            logo: '18_esp/AC',
            coordinates: 'H28',
            color: '#B75835',
            tokens: [0],
            type: 'minor',
            shares: [100],
            float_percent: 100,
            max_ownership_percent: 100,
            startable: true,
          },
          {
            sym: 'MZ',
            name: 'Ferrocarril de Madrid a Zaragoza',
            logo: '18_esp/MZ',
            coordinates: 'F24',
            city: 2,
            color: '#7E7F7E',
            tokens: [0],
            type: 'minor',
            shares: [100],
            float_percent: 100,
            max_ownership_percent: 100,
            startable: true,
            abilities: [{ type: 'token', hexes: ['F24'], cheater: true, when: 'track', price: 0 }],
          },
          {
            sym: 'ZP',
            name: 'Compañía del Ferrocarril de Zaragoza a Pamplona',
            logo: '18_esp/ZP',
            coordinates: 'J20',
            city: 0,
            color: '#D90072',
            tokens: [0],
            type: 'minor',
            shares: [100],
            float_percent: 100,
            max_ownership_percent: 100,
            startable: true,
          },
        ].freeze
      end
    end
  end
end
