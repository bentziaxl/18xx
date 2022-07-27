# frozen_string_literal: true

module Engine
  module Game
    module G18ESP
      module Map
        LAYOUT = :flat
        TILES = {
          '3' => 4,
          '4' => 6,
          '5' => 4,
          '6' => 4,
          '7' => 4,
          '8' => 14,
          '9' => 12,
          '57' => 4,
          '58' => 6,
          '72' => 6,
          '74' => 6,
          '73' => 6,
          '75' => 2,
          '76' => 2,
          '77' => 5,
          '79' => 6,
          '78' => 6,
          '956' => 2,
          'L0' => {
            'count' => 1,
            'color' => 'green',
            'code' =>
              'town=revenue:10;town=revenue:10;path=a:0,b:_0;path=a:3,b:_0;' \
              'path=a:5,b:_0;path=a:2,b:_1;path=a:4,b:_1;icon=image:18_esp/strawberry',
          },

          # greens

          '14' => 4,
          '15' => 4,
          '16' => 1,
          '19' => 1,
          '20' => 1,
          '23' => 1,
          '24' => 3,
          '25' => 2,
          '26' => 2,
          '27' => 2,
          '28' => 1,
          '29' => 1,
          '30' => 1,
          '31' => 1,
          '87' => 2,
          '88' => 2,
          '204' => 2,
          '619' => 4,
          '710' => 1,
          '711' => 1,
          '712' => 1,
          '713' => 1,
          '714' => 1,
          '715' => 1,
          'L1' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40,slots:2;path=a:1,b:_0;path=a:2,b:_0;label=B',
          },
          'L2' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40;city=revenue:40;city=revenue:40;path=a:0,b:_0;path=a:1,b:_0;' \
            'path=a:2,b:_1;path=a:3,b:_1;path=a:4,b:_2;path=a:0,b:_2;label=M',
          },
          'L3' => {
            'count' => 2,
            'color' => 'green',
            'code' =>
            'city=revenue:30,slots:2;path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow',
          },
          'L4' => {
            'count' => 2,
            'color' => 'green',
            'code' =>
            'city=revenue:30,slots:2;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;path=a:4,b:_0,track:narrow',
          },
          'L5' => {
            'count' => 2,
            'color' => 'green',
            'code' =>
           'city=revenue:30,slots:2;path=a:0,b:_0,track:narrow;path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow',
          },
          'L6' => {
            'count' => 2,
            'color' => 'green',
            'code' =>
          'city=revenue:30,slots:2;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:narrow',
          },
          'L7' => {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;' \
            'path=a:5,b:_0,track:narrow;path=a:3,b:_0,track:dual;label=G',
          },
          'L8' => {
            'count' => 1,
            'color' => 'green',
            'code' =>
              'city=revenue:40;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow;' \
              'path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:dual;label=G',
          },
          'L9' => {
            'count' => 1,
            'color' => 'green',
            'code' =>
                'city=revenue:40;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow;' \
                'path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:dual;label=Bi',
          },
          'L10' => {
            'count' => 1,
            'color' => 'green',
            'code' =>
                  'city=revenue:40;path=a:1,b:_0,track:narrow;path=a:2,b:_0,track:narrow;' \
                  'path=a:4,b:_0,track:narrow;path=a:3,b:_0,track:dual;label=Bi',
          },
          'IR26' => { 'count' => 1, 'color' => 'green', 'code' => 'path=a:0,b:3;path=a:1,b:2,track:narrow' },
          'IR27' => { 'count' => 1, 'color' => 'green', 'code' => 'path=a:0,b:3,track:narrow;path=a:1,b:2' },
          'IR28' => { 'count' => 1, 'color' => 'green', 'code' => 'path=a:1,b:3,track:narrow;path=a:0,b:4' },
          'IR29' => { 'count' => 1, 'color' => 'green', 'code' => 'path=a:0,b:1,track:narrow;path=a:2,b:4' },
          'IR30' => { 'count' => 1, 'color' => 'green', 'code' => 'path=a:1,b:2,track:narrow;path=a:0,b:4' },
          'IR31' => { 'count' => 1, 'color' => 'green', 'code' => 'path=a:1,b:2;path=a:0,b:4,track:narrow' },
          'IR32' => { 'count' => 1, 'color' => 'green', 'code' => 'path=a:0,b:1;path=a:2,b:4,track:narrow' },
          'IR33' => { 'count' => 1, 'color' => 'green', 'code' => 'path=a:0,b:1;path=a:2,b:3,track:narrow' },
          'IR34' => { 'count' => 1, 'color' => 'green', 'code' => 'path=a:0,b:1,track:narrow;path=a:3,b:4' },
          'IR35' => { 'count' => 1, 'color' => 'green', 'code' => 'path=a:0,b:1,track:narrow;path=a:2,b:3' },
          '141a' => {
            'count' => 3,
            'color' => 'green',
            'code' => 'town=revenue:10;path=a:0,b:_0,track:narrow;path=a:3,b:_0,track:narrow;path=a:1,b:_0,track:narrow',
          },
          '142b' => {
            'count' => 3,
            'color' => 'green',
            'code' => 'town=revenue:10;path=a:0,b:_0,track:narrow;path=a:5,b:_0,track:narrow;path=a:3,b:_0,track:narrow',
          },
          '143a' => {
            'count' => 3,
            'color' => 'green',
            'code' => 'town=revenue:10;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow;path=a:2,b:_0,track:narrow',
          },
          '144a' => {
            'count' => 3,
            'color' => 'green',
            'code' => 'town=revenue:10;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;path=a:4,b:_0,track:narrow',
          },

          # browns
          '39' => 1,
          '40' => 1,
          '41' => 1,
          '42' => 1,
          '43' => 1,
          '44' => 1,
          '45' => 1,
          '46' => 1,
          '47' => 1,
          '70' => 1,
          '611' => 8,
          '105a' => {
            'count' => 1,
            'color' => 'brown',
            'code' => 'city=revenue:50,slots:3;path=a:1,b:_0;path=a:2,b:_0;path=a:4,b:_0;label=B',
          },
          '795a' => {
            'count' => 1,
            'color' => 'brown',
            'code' => 'city=revenue:60,slots:4;path=a:0,b:_0;path=a:1,b:_0;path=a:2,b:_0;'\
                      'path=a:3,b:_0;path=a:4,b:_0;label=M',
          },
          '193a' => {
            'count' => 1,
            'color' => 'brown',
            'code' => 'city=revenue:50,slots:2;path=a:0,b:_0;path=a:1,b:_0;path=a:2,b:_0;path=a:3,b:_0;label=V',
          },
          '933' =>
          {
            'count' => 2,
            'color' => 'brown',
            'code' => 'town=revenue:20;path=a:0,b:_0;path=a:1,b:_0;path=a:2,b:_0;path=a:4,b:_0;path=a:5,b:_0',
          },
          '145b' =>
          {
            'count' => 1,
            'color' => 'brown',
            'code' => 'town=revenue:20;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow;'\
                      'path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow',
          },
          '146a' =>
          {
            'count' => 1,
            'color' => 'brown',
            'code' => 'town=revenue:20;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow;'\
                      'path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:narrow',
          },
          '147a' =>
          {
            'count' => 1,
            'color' => 'brown',
            'code' => 'town=revenue:20;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
                      'path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow',
          },

          '909a' => {
            'count' => 1,
            'color' => 'brown',
            'code' => 'city=revenue:50,slots:3;path=a:0,b:_0,track:dual;' \
                      'path=a:1,b:_0,track:dual;path=a:2,b:_0,track:dual;path=a:3,b:_0,track:dual;' \
                      'path=a:4,b:_0,track:dual;label=G',
          },
          '220a' => {
            'count' => 1,
            'color' => 'brown',
            'code' => 'city=revenue:50,slots:3;path=a:0,b:_0,track:dual;path=a:1,b:_0,track:dual;' \
                      'path=a:2,b:_0,track:dual;path=a:3,b:_0,track:dual;'\
                      'path=a:4,b:_0,track:dual;path=a:5,b:_0,track:dual;label=Bi',
          },
          '216a' => {
            'count' => 5,
            'color' => 'brown',
            'code' => 'city=revenue:40,slots:2;path=a:0,b:_0,track:dual;' \
                      'path=a:1,b:_0,track:dual;path=a:2,b:_0,track:dual;path=a:3,b:_0,track:dual;' \
                      'path=a:4,b:_0,track:dual',
          },

          # gray
          '455' => 2,
          '895a' => {
            'count' => 1,
            'color' => 'gray',
            'code' => 'city=revenue:50,slots:2;path=a:0,b:_0,track:dual;path=a:1,b:_0,track:dual;' \
                      'path=a:2,b:_0,track:dual;path=a:3,b:_0,track:dual;path=a:4,b:_0,track:dual;path=a:5,b:_0,track:dual',
          },
          '240a' => {
            'count' => 1,
            'color' => 'gray',
            'code' => 'city=revenue:70,slots:3;path=a:0,b:_0;path=a:1,b:_0;path=a:2,b:_0;path=a:3,b:_0;label=B',
          },
          '910a' => {
            'count' => 1,
            'color' => 'gray',
            'code' => 'city=revenue:80,slots:4;path=a:0,b:_0;path=a:1,b:_0;path=a:2,b:_0;path=a:3,b:_0;path=a:4,b:_0;label=M',
          },
          '912a' => {
            'count' => 1,
            'color' => 'gray',
            'code' => 'town=revenue:10;path=a:0,b:_0;path=a:1,b:_0;path=a:2,b:_0;path=a:3,b:_0;path=a:4,b:_0;path=a:5,b:_0',
          },

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
