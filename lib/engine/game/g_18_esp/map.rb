# frozen_string_literal: true

module Engine
  module Game
    module G18ESP
      module Map
        LAYOUT = :flat
        TILES = {
          '1' => 1,
          '2' => 1,
          '5' => 3,
          '6' => 4,
          '7' => 4,
          '8' => 9,
          '9' => 12,
          '14' => 3,
          '15' => 6,
          '16' => 1,
          '18' => 1,
          '19' => 1,
          '20' => 1,
          '23' => 2,
          '24' => 2,
          '25' => 2,
          '26' => 1,
          '27' => 1,
          '28' => 1,
          '29' => 1,
          '30' => 1,
          '31' => 1,
          '39' => 1,
          '40' => 1,
          '41' => 1,
          '42' => 1,
          '43' => 1,
          '44' => 1,
          '45' => 1,
          '46' => 1,
          '47' => 1,
          '55' => 1,
          '56' => 1,
          '57' => 3,
          '59' => 2,
          '64' => 1,
          '65' => 1,
          '66' => 1,
          '67' => 1,
          '68' => 1,
          '69' => 1,
          '70' => 1,
          '235' => 3,
          '236' => 2,
          '237' => 1,
          '238' => 1,
          '239' => 3,
          '240' => 2,
          '241' => {
            'count' => 1,
            'color' => 'blue',
            'code' => 'offboard=revenue:50;icon=image:anchor;path=a:2,b:_0;path=a:1,b:_0',
          },
          '611' => 4,
          '915' => 1,
        }.freeze

        LOCATION_NAMES = {
          'A4' => 'La Coruna Ferrol Lugo',
          'B9' => 'Ourense Lugo Pontevedra',
          'B11' => 'Vigo Portgual',
          'B3' => 'Ribadeo',
          'C4' => 'lluarca',
          'C10' => 'Ponferrada',
          'E2' => 'Candas',
          'E4' => 'Aviles',
          'E6' => 'Oviedo',
          'E8' => 'Mieres',
          'F3' => 'Gijon',
          'F5' => 'Siero',
          'F7' => 'Langero',
          'G4' => 'Ribadesella',
          'G6' => 'Cangas de Onis',
          'H5' => 'Llanes',
          'I4' => 'Torrelavega',
          'I8' => 'Reinosa',
          'J5' => 'Santander',
          'K4' => 'Laredo',
          'K6' => 'Balmaseda',
          'L5' => 'Bilbao',
          'N5' => 'Irun',
          'D1' => 'San Esteban de Pravia harbor',
          'F1' => 'Gijon harbor',
          'L3' => 'Bilbao harbor',
        }.freeze

        HEXES = {
          blue: {
            %w[D1] => 'offboard=revenue:yellow_40|green_30|brown_20|gray_20;path=a:0,b:_0,track:dual',
            %w[F1 L3] => 'offboard=revenue:yellow_10|green_20|brown_30|gray_40;path=a:0,b:_0,track:dual',
          },
          red: {
            %w[A4 B9] =>
                     'offboard=revenue:yellow_10|green_30|brown_40|gray_50;path=a:4,b:_0;path=a:5,b:_0;label=W',
            %w[B11] =>
                     'offboard=revenue:yellow_10|green_30|brown_40|gray_50;path=a:4,b:_0;label=W',
            ['N5'] =>
                   'offboard=revenue:yellow_20|green_30|brown_50|gray_60;path=a:1,b:_0;path=a:2,b:_0;label=E',
          },
          yellow: {
            ['F3'] => 'city=revenue:30;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:dual;label=G',
            ['L5'] => 'city=revenue:30;path=a:1,b:_0,track:narrow;path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:dual;label=Bi',
          },
          white: {
            %w[B5 C6 C8 M4] => '',
            %w[C4 E2 E4 H5 I4 K4] => 'town=revenue:0',
            %w[B3 C10 J5] => 'city=revenue:0',
            %w[D5 D9 F9 F11 H9 I6 J7] => 'icon=image:18_usa/mine',
            %w[E8 F7] => 'city=revenue:0;icon=image:18_usa/mine',
            %w[E6] => 'city=revenue:0;upgrade=cost:20,terrain:river',
            %w[G4 G6] => 'town=revenue:0;upgrade=cost:20,terrain:river',
            %w[D7 D11 G10 H7 J9] => 'upgrade=cost:80,terrain:mountain',
            %w[E10 G8 I10 K8 L7 M6] => 'upgrade=cost:60,terrain:mountain',
            %w[I8] => 'city=revenue:0;upgrade=cost:60,terrain:mountain',
            %w[K6] => 'town=revenue:0;upgrade=cost:60,terrain:mountain',
            %w[F5] => 'town=revenue:0;upgrade=cost:80,terrain:mountain',
          },
          gray: {
            ['D3'] => 'town=revenue:0;path=a:1,b:_0,track:narrow;path=a:3,b:_0,track:narrow;path=a:5,b:_0,track:narrow;',
          },
        }.freeze
      end
    end
  end
end
