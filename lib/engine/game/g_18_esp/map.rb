# frozen_string_literal: true

module Engine
  module Game
    module G18ESP
      module Map
        MINE_HEXES = %w[D5 D9 F9 F11 F19 H9 I6 J7 D23 H21 E18 E32 F31 I30 J23 E8 F7 C30 G30 G32 J21].freeze
        LAYOUT = :flat
        TILES = {
          '3' => 3,
          '4' => 3,
          '5' => 3,
          '6' => 3,
          '7' => 4,
          '8' => 14,
          '9' => 12,
          '57' => 3,
          '58' => 5,
          '72' => 4,
          '73' => 3,
          '74' => 4,
          '76' => 4,
          '77' => 5,
          '78' => 6,
          '79' => 6,
          '201' => 1,
          '202' => 1,
          '621' => 1,
          'L79' => {
            'count' => 1,
            'color' => 'yellow',
            'code' =>
              'town=revenue:yellow_10|brown_30;town=revenue:10;path=a:0,b:_0;path=a:3,b:_0;' \
              'path=a:5,b:_0;path=a:2,b:_1;path=a:4,b:_1',
          },
          'L102' => {
            'count' => 1,
            'color' => 'yellow',
            'code' =>
              'city=revenue:30;path=a:0,b:_0,track:narrow;path=a:3,b:_0,track:narrow;label=G;label=O',
          },
          'L103' => {
            'count' => 1,
            'color' => 'yellow',
            'code' =>
              'city=revenue:30;path=a:0,b:_0,track:narrow;path=a:4,b:_0,track:narrow;label=G;label=O',
          },
          'L104' => {
            'count' => 1,
            'color' => 'yellow',
            'code' =>
              'city=revenue:30;path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow;label=G;label=O',
          },

          # greens

          '14' => 3,
          '15' => 3,
          '16' => 1,
          '18' => 1,
          '19' => 1,
          '20' => 1,
          '23' => 3,
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
          '89' => 2,
          '116' => 2,
          '204' => 2,
          '208' => 1,
          '207' => 1,
          '622' => 1,
          '619' => 3,
          'L80' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40,slots:2;path=a:0,b:_0;path=a:3,b:_0;path=a:4,b:_0;label=K;icon=image:anchor',
          },
          'L81' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40,slots:2;path=a:0,b:_0;path=a:2,b:_0;path=a:3,b:_0;label=K;icon=image:anchor',
          },
          'L82' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40,slots:2;path=a:2,b:_0;path=a:3,b:_0;path=a:4,b:_0;label=K;icon=image:anchor',
          },
          'L91' =>
          {
            'count' => 2,
            'color' => 'green',
            'code' =>
            'junction;path=a:1,b:5;path=a:1,b:2;path=a:2,b:5;path=a:0,b:_0,track:narrow;path=a:3,b:_0,track:narrow;'\
            'path=a:4,b:_0,track:narrow',
          },
          'L92' =>
          {
            'count' => 2,
            'color' => 'green',
            'code' =>
            'junction;path=a:1,b:5;path=a:1,b:4;path=a:4,b:5;path=a:0,b:_0,track:narrow;'\
            'path=a:3,b:_0,track:narrow;path=a:2,b:_0,track:narrow',
          },
          'L93' =>
          {
            'count' => 2,
            'color' => 'green',
            'code' =>
            'junction;path=a:1,b:5;path=a:1,b:3;path=a:3,b:5;path=a:0,b:_0,track:narrow;'\
            'path=a:4,b:_0,track:narrow;path=a:2,b:_0,track:narrow',
          },
          'L94' =>
          {
            'count' => 2,
            'color' => 'green',
            'code' =>
            'junction;path=a:0,b:1;path=a:0,b:5;path=a:1,b:5;path=a:2,b:_0,track:narrow;'\
            'path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow',
          },

          'L95' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'town=revenue:20;path=a:0,b:_0;path=a:1,b:_0;path=a:3,b:_0;path=a:5,b:_0;'\
            'path=a:2,b:_0,track:narrow;path=a:4,b:_0,track:narrow;icon=image:18_esp/mine;label=PAL',
          },
          'L96' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'town=revenue:20;path=a:0,b:_0;path=a:1,b:_0;path=a:5,b:_0;'\
            'path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:narrow;'\
            'path=a:4,b:_0,track:narrow;icon=image:18_esp/mine;label=PAL',
          },
          'L97' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'town=revenue:20;path=a:0,b:_0;path=a:5,b:_0;'\
            'path=a:1,b:_0,track:narrow;path=a:4,b:_0,track:narrow;icon=image:18_esp/mine;label=BUR',
          },
          'L98' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'town=revenue:20;path=a:0,b:_0;path=a:3,b:_0;path=a:5,b:_0;'\
            'path=a:1,b:_0,track:narrow;path=a:4,b:_0,track:narrow;label=VIT',
          },
          'L99' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'town=revenue:20;path=a:1,b:_0;path=a:5,b:_0;'\
            'path=a:1,b:_0,track:narrow;path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow;label=VIT',
          },
          'L100' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:30,slots:2;path=a:1,b:_0,track:narrow;path=a:2,b:_0,track:narrow;path=a:4,b:_0,track:narrow;'\
            'path=a:0,b:_0;path=a:5,b:_0;label=SEB',
          },
          'L101' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:30,slots:2;path=a:1,b:_0,track:narrow;path=a:0,b:_0;'\
            'path=a:2,b:_0;path=a:4,b:_0;path=a:5,b:_0;label=SEB',
          },
          'L105' =>
          {
            'count' => 3,
            'color' => 'green',
            'code' =>
            'city=revenue:30,slots:2;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
            'path=a:4,b:_0,track:narrow;path=a:3,b:_0;path=a:5,b:_0',
          },
          'L106' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40,slots:2;path=a:1,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
            'path=a:5,b:_0,track:narrow;path=a:0,b:_0;label=Bi',
          },
          'L107' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40,slots:2;path=a:1,b:_0,track:narrow;path=a:2,b:_0,track:narrow;path=a:5,b:_0,track:narrow;label=G',
          },
          'L108' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40,slots:2;path=a:1,b:_0,track:narrow;path=a:4,b:_0,track:narrow;path=a:5,b:_0,track:narrow;label=G',
          },
          'L109' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:50,slots:2;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
            'path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow;path=a:1,b:_0;label=O',
          },
          'L110' =>
          {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:50,slots:2;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
            'path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow;path=a:5,b:_0;label=O',
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
          '216' => 2,
          '611' => 8,
          '933' =>
          {
            'count' => 2,
            'color' => 'brown',
            'code' => 'town=revenue:20;path=a:0,b:_0;path=a:2,b:_0;path=a:3,b:_0;path=a:4,b:_0;path=a:5,b:_0',
          },

          'L85' => {
            'count' => 1,
            'color' => 'brown',
            'code' => 'city=revenue:70,slots:3;path=a:1,b:_0;path=a:2,b:_0;path=a:3,b:_0;path=a:4,b:_0;label=B',
          },
          'L86' => {
            'count' => 1,
            'color' => 'brown',
            'code' => 'city=revenue:80,slots:4;path=a:0,b:_0;path=a:1,b:_0;path=a:2,b:_0;path=a:3,b:_0;'\
                      'path=a:4,b:_0;label=M',
          },
          'L87' => {
            'count' => 1,
            'color' => 'brown',
            'code' => 'city=revenue:50,slots:3;path=a:0,b:_0;path=a:3,b:_0;path=a:4,b:_0;path=a:5,b:_0;'\
                      'icon=image:anchor;label=K',
          },
          'L88' => {
            'count' => 1,
            'color' => 'brown',
            'code' => 'city=revenue:60,slots:2;path=a:0,b:_0;path=a:3,b:_0;path=a:4,b:_0;path=a:5,b:_0;'\
                      'icon=image:anchor;label=K',
          },
          'L111' =>
          {
            'count' => 3,
            'color' => 'brown',
            'code' =>
            'city=revenue:40,slots:2;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
            'path=a:4,b:_0,track:narrow;path=a:1,b:_0;path=a:3,b:_0;path=a:5,b:_0',
          },
          'L112' =>
          {
            'count' => 1,
            'color' => 'brown',
            'code' =>
            'city=revenue:50,slots:2;path=a:1,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
            'path=a:5,b:_0,track:narrow;path=a:0,b:_0;path=a:4,b:_0;label=Bi',
          },
          'L113' =>
          {
            'count' => 1,
            'color' => 'brown',
            'code' =>
            'city=revenue:50,slots:2;path=a:1,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
            'path=a:5,b:_0,track:narrow;path=a:0,b:_0;label=G',
          },
          'L114' =>
          {
            'count' => 1,
            'color' => 'brown',
            'code' =>
            'city=revenue:50,slots:2;path=a:1,b:_0,track:narrow;path=a:4,b:_0,track:narrow;'\
            'path=a:5,b:_0,track:narrow;path=a:0,b:_0;label=G',
          },
          'L115' =>
          {
            'count' => 1,
            'color' => 'brown',
            'code' =>
            'city=revenue:50,slots:2;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
            'path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow;path=a:1,b:_0;path=a:5,b:_0;label=O',
          },

          # gray
          'X11b' => {
            'count' => 1,
            'color' => 'gray',
            'code' => 'city=revenue:60,slots:3;path=a:0,b:_0;path=a:1,b:_0;path=a:3,b:_0;path=a:4,b:_0;path=a:5,b:_0;label=Y',
          },
          '455' => 2,
          'L38' =>
          {
            'count' => 2,
            'color' => 'gray',
            'code' => 'town=revenue:30;path=a:0,b:_0;path=a:1,b:_0;path=a:2,b:_0;path=a:3,b:_0;path=a:4,b:_0;path=a:5,b:_0',
          },
          'L89' => {
            'count' => 1,
            'color' => 'gray',
            'code' => 'city=revenue:90,slots:3;path=a:1,b:_0;path=a:2,b:_0;path=a:3,b:_0;path=a:4,b:_0;label=B',
          },
          'L90' => {
            'count' => 1,
            'color' => 'gray',
            'code' => 'city=revenue:100,slots:4;path=a:0,b:_0;path=a:1,b:_0;path=a:2,b:_0;path=a:3,b:_0;'\
                      'path=a:4,b:_0;label=M',
          },

        }.freeze

        LOCATION_NAMES = {
          'B5' => 'Galicia',
          'B9' => 'Vigo',
          'B11' => 'Vigo',
          'B3' => 'Ribadeo',
          'C4' => 'Luarca (Ḷḷuarca)',
          'C10' => 'Ponferrada',
          'E2' => 'Avilés',
          'E6' => 'Oviedo (Uviéu)',
          'E8' => 'Mieres',
          'D3' => 'Muros de Nalón',
          'F3' => 'Gijón (Xixón)',
          'F7' => 'Langero (Llangréu)',
          'G4' => 'Ribadesella (Ribeseya)',
          'G6' => 'Cangas de Onis',
          'H5' => 'Llanes',
          'I4' => 'Torrelavega',
          'I8' => 'Reinosa',
          'J5' => 'Santander',
          'K4' => 'Laredo',
          'K6' => 'Balmaseda',
          'L5' => 'Bilbao (Bilbo)',
          'N5' => 'Irún (Irun)',
          'D1' => 'San Esteban de Pravia harbor',
          'F1' => 'Gijón harbor',
          'L3' => 'Bilbao harbor',
          'E12' => 'Pajares Mountain Pass',
          'I12' => 'Alar del Rey Mountain Pass',
          'K10' => 'País Vasco (Euskadi) Mountain Pass 1',
          'M8' => 'País Vasco (Euskadi) Mountain Pass 2',

          # south map
          'D21' => 'Porto',
          'C24' => 'Castelo Branco',
          'B25' => 'Lisboa',
          'B29' => 'Faro',
          'C26' => 'Badajoz',
          'C30' => 'Huelva',
          'D25' => 'Cáceres',
          'D31' => 'Sevilla',
          'D33' => 'Cádiz',
          'E18' => 'León',
          'E20' => 'Zamora',
          'E22' => 'Salamanca',
          'F19' => 'Palencia',
          'F21' => 'Valladolid',
          'F29' => 'Córdoba',
          'F33' => 'Málaga',
          'C34' => 'Cádiz harbor',
          'G18' => 'Burgos',
          'G24' => 'Madrid',
          'G26' => 'Toledo and Aranjuez',
          'G28' => 'Ciudad Real',
          'G30' => 'Linares',
          'G32' => 'Granada',
          'G34' => 'Málaga harbor',
          'H17' => 'Vitoria',
          'H23' => 'Guadalajara',
          'H27' => 'Alcázar de San Juan',
          'I16' => 'San Sebastián (Donostia)',
          'I28' => 'Albacete',
          'I32' => 'Almería',
          'J15' => 'Bayonne',
          'J17' => 'Pamplona (Iruña)',
          'J21' => 'Calatayud',
          'J29' => 'Murcia',
          'K20' => 'Zaragoza',
          'K24' => 'Teruel',
          'K28' => 'Alicante',
          'K30' => 'Cartagena',
          'K32' => 'Cartagena harbor',
          'L15' => 'Paris',
          'L19' => 'Lérida (Lleida)',
          'L23' => 'Castellón (Castelló)',
          'L25' => 'Valencia (València)',
          'M16' => 'Toulouse',
          'M22' => 'Tarragona',
          'M24' => 'Valencia harbor',
          'N21' => 'Barcelona',
          'O18' => 'Perpignan',
          'O20' => 'Gerona (Girona)',
          'O22' => 'Barcelona harbor',

        }.freeze

        HEXES = {
          blue: {
            %w[D1] => 'offboard=revenue:yellow_40|green_30|brown_20|gray_20',
            %w[F1 L3] => 'offboard=revenue:yellow_20|green_30|brown_40|gray_50',
            %w[M24] => 'offboard=revenue:yellow_20|green_30|brown_50|gray_60',
            %w[K32] => 'offboard=revenue:yellow_40|green_30|brown_30|gray_40',
            %w[G34] => 'offboard=revenue:yellow_20|green_30|brown_30|gray_40',
            %w[C34] => 'offboard=revenue:yellow_20|green_30|brown_30|gray_40',
            %w[O22] => 'offboard=revenue:yellow_20|green_30|brown_50|gray_60',
          },
          red: {
            %w[B5] =>
                     'offboard=revenue:yellow_10|green_30|brown_40|gray_50;'\
                     'path=a:4,b:_0,track:dual;path=a:5,b:_0,track:dual;label=W',
            ['B9'] => 'offboard=revenue:yellow_20|green_30|brown_40|gray_50;'\
                      'path=a:4,b:_0,track:dual;path=a:5,b:_0,track:dual;label=W',
            %w[B11] =>
                     'offboard=revenue:yellow_20|green_30|brown_40|gray_50,hide:1;path=a:4,b:_0,track:dual;label=W',
            ['N5'] =>
                   'offboard=revenue:yellow_20|green_30|brown_50|gray_60;'\
                   'path=a:1,b:_0,track:dual;path=a:2,b:_0,track:dual;label=E',
            ['D21'] => 'offboard=revenue:yellow_20|green_30|brown_50|gray_60;'\
                       'path=a:4,b:_0,track:dual;path=a:5,b:_0,track:dual;border=edge:2;label=W',
            ['C24'] => 'offboard=revenue:yellow_10|green_20|brown_40|gray_50;path=a:0,b:_0,track:dual;'\
                       'path=a:4,b:_0,track:dual;path=a:5,b:_0,track:dual;label=W',
            %w[B25 B29] => 'offboard=revenue:yellow_20|green_30|brown_50|gray_50,hide:1;path=a:5,b:_0,track:dual;label=W',
            ['B27'] => 'offboard=revenue:yellow_20|green_30|brown_50|gray_60;'\
                       'path=a:4,b:_0,track:dual;path=a:5,b:_0,track:dual;label=W',
            ['B31'] => 'offboard=revenue:yellow_10|green_20|brown_40|gray_50;path=a:4,b:_0,track:dual;label=W',
            %w[N17
               J15] => 'offboard=revenue:yellow_20|green_30|brown_50|gray_60;'\
                       'path=a:0,b:_0,track:dual;path=a:1,b:_0,track:dual;label=E',
            %w[O18] => 'offboard=revenue:yellow_20|green_30|brown_40|gray_50;'\
                       'path=a:0,b:_0,track:dual;path=a:1,b:_0,track:dual;label=E',
            %w[K16] => 'offboard=revenue:yellow_30|green_50|brown_60|gray_80'\
                       ';path=a:0,b:_0,track:dual;path=a:5,b:_0,track:dual;label=E',
            %w[L15] => 'offboard=revenue:yellow_20|green_30|brown_40|gray_50,hide:1;path=a:0,b:_0,track:dual;label=E',
            %w[M16] => 'offboard=revenue:yellow_20|green_30|brown_50|gray_60,hide:1;path=a:0,b:_0,track:dual;label=E',
          },
          yellow: {
            %w[G18] => 'town=revenue:10;path=a:1,b:_0,track:narrow;' \
                       'path=a:4,b:_0,track:narrow;icon=image:18_esp/mine,sticky:1;'\
                       'future_label=label:BUR,color:green',
            ['L5'] => 'city=revenue:30;path=a:1,b:_0,track:narrow;path=a:2,b:_0,track:narrow;label=Bi;' \
                      'icon=image:18_esp/FdSB,sticky:1;icon=image:18_esp/FdLR,sticky:1;'\
                      'frame=color:#35A7FF;icon=image:anchor',
            ['G24'] => 'city=revenue:40;city=revenue:40;city=revenue:40;path=a:0,b:_0;path=a:1,b:_0;' \
                       'path=a:2,b:_1;path=a:4,b:_2;path=a:0,b:_2;label=M',
            ['N21'] => 'city=revenue:30;city=revenue:30;path=a:1,b:_0;path=a:2,b:_1;label=B;icon=image:18_esp/ZP,sticky:1;'\
                       'frame=color:#35A7FF;icon=image:anchor',
          },
          white: {
            %w[C6 C8 M4 C28 I26 J27 J31 K26 L27 M20 E4 E34] => '',
            %w[B3 C4 C10 E2 I4 K4] => 'town=revenue:0',
            %w[K30] => 'town=revenue:0;icon=image:18_esp/AC,sticky:1;frame=color:#35A7FF;icon=image:anchor',
            %w[D33] => 'town=revenue:0;icon=image:18_esp/SC,sticky:1;frame=color:#35A7FF;icon=image:anchor',
            %w[H5] => 'town=revenue:0;icon=image:18_esp/CFEA,sticky:1;border=edge:0,type:impassable',
            %w[J5 L19 M22] => 'city=revenue:0',
            ['F3'] => 'city=revenue:0;frame=color:#35A7FF;icon=image:anchor;label=G',
            %w[F33] => 'city=revenue:0;icon=image:18_esp/CM,sticky:1;'\
                       'future_label=label:K,color:green;frame=color:#35A7FF;icon=image:anchor',
            %w[L25] => 'city=revenue:0;future_label=label:K,color:green;frame=color:#35A7FF;icon=image:anchor',
            %w[D5 D9 F9 F11 H9 J7 D23 H21 E32 F31 J23] => 'icon=image:18_esp/mine,sticky:1',
            %w[I6] => 'icon=image:18_esp/mine,sticky:1;border=edge:1,type:impassable',
            %w[I30] => 'icon=image:18_esp/mine,sticky:1;border=edge:2,type:impassable',
            %w[E8 G32] => 'city=revenue:0;icon=image:18_esp/mine,sticky:1',
            %w[F7] => 'city=revenue:0;icon=image:18_esp/mine,sticky:1;icon=image:18_esp/CFLG,sticky:1',
            %w[E6 C26 D27] => 'city=revenue:0;upgrade=cost:20,terrain:river',
            %w[K20] => 'city=revenue:0;upgrade=cost:20,terrain:river;' \
                       'icon=image:18_esp/ZPB,sticky:1;icon=image:18_esp/MZ,sticky:1',
            %w[D31] => 'city=revenue:0;upgrade=cost:20,terrain:river;'\
                       'icon=image:18_esp/MS,sticky:1;icon=image:18_esp/A,sticky:1;label=Y',
            %w[F21] => 'city=revenue:0;upgrade=cost:20,terrain:river;icon=image:18_esp/N,sticky:1',
            %w[G4 G6] => 'town=revenue:0;upgrade=cost:20,terrain:river',
            %w[L21] => 'upgrade=cost:20,terrain:river',
            %w[F5 D7 D11 G10 J9 M18 N19] => 'upgrade=cost:80,terrain:mountain',
            %w[H7] => 'upgrade=cost:80,terrain:mountain;border=edge:3,type:impassable;border=edge:4,type:impassable',
            %w[E10 G8 I10 K8 L7 M6 I22 I24 K22] => 'upgrade=cost:60,terrain:mountain',
            %w[H29] => 'upgrade=cost:60,terrain:mountain;border=edge:5,type:impassable',
            %w[I8] => 'city=revenue:0;upgrade=cost:60,terrain:mountain',
            %w[K6] => 'town=revenue:0;upgrade=cost:60,terrain:mountain',
            %w[I28] => 'city=revenue:0;upgrade=cost:30,terrain:mountain',
            %w[J17] => 'town=revenue:0;upgrade=cost:80,terrain:mountain',
            %w[E20] => 'town=revenue:0;upgrade=cost:10,terrain:river',
            %w[D25] => 'city=revenue:0;upgrade=cost:10,terrain:river;' \
                       'icon=image:18_esp/MCP,sticky:1',
            %w[F29 J29] => 'city=revenue:0;upgrade=cost:10,terrain:river',
            %w[K28] => 'city=revenue:0;upgrade=cost:10,terrain:river;icon=image:18_esp/MZA,sticky:1;label=Y',
            %w[G20 E24 E26 E30 I18 J19 H25] => 'upgrade=cost:10,terrain:river',
            %w[E22] => 'city=revenue:0;upgrade=cost:30,terrain:mountain',
            %w[F19] => 'town=revenue:0;icon=image:18_esp/mine,sticky:1;frame=color:#6CD976;future_label=label:PAL,color:green',
            %w[H17] => 'town=revenue:0;frame=color:#6CD976;future_label=label:VIT,color:green',
            %w[I16] => 'city=revenue:0;frame=color:#6CD976;future_label=label:SEB,color:green',
            %w[C30 G30 J21] => 'town=revenue:0;icon=image:18_esp/mine,sticky:1',
            %w[F23 F25 G22 H19 I20 J25 H33] => 'upgrade=cost:40,terrain:mountain',
            %w[I32 K24 L23 O20] => 'town=revenue:0;upgrade=cost:40,terrain:mountain',
            %w[H31] => 'upgrade=cost:120,terrain:mountain',
            %w[K18 L17] => 'upgrade=cost:100,terrain:mountain',
            %w[D29 E28 F27] => 'upgrade=cost:20,terrain:mountain',
            %w[H23] => 'town=revenue:0;upgrade=cost:20,terrain:mountain',
            %w[G28] => 'town=revenue:0;upgrade=cost:20,terrain:mountain;icon=image:18_esp/CRB,sticky:1',
            %w[G26] => 'town=revenue:0;town=revenue:0;upgrade=cost:20,terrain:river',

          },
          gray: {
            ['D3'] => 'town=revenue:10;path=a:1,b:_0,track:narrow;path=a:0,b:_0,track:narrow;'\
                      'path=a:5,b:_0,track:narrow;frame=color:#35A7FF;icon=image:anchor',
            ['E18'] => 'city=revenue:30,slots:2;path=a:0,b:_0;path=a:3,b:_0;path=a:5,b:_0,track:narrow;icon=image:18_esp/mine',
            ['H27'] => 'city=revenue:30,slots:2;path=a:1,b:_0;path=a:2,b:_0;path=a:4,b:_0;path=a:5,b:_0;',
            ['H11'] => 'offboard=revenue:10;path=a:2,b:_0,track:dual;path=a:3,b:_0,track:dual;path=a:4,b:_0,track:dual;',
            %w[J11 L9] => 'offboard=revenue:10;path=a:2,b:_0,track:dual;path=a:3,b:_0,track:dual',
          },
          orange: {
            ['E12'] => 'city=revenue:0;path=a:3,b:_0,track:dual;path=a:0,b:_0,track:dual;label=120;icon=image:18_esp/60',
            ['I12'] => 'city=revenue:0;path=a:3,b:_0,track:dual;path=a:1,b:_0,track:dual;label=60;icon=image:18_esp/30',
            ['K10'] => 'city=revenue:0;path=a:3,b:_0,track:dual;path=a:0,b:_0,track:dual;label=80;icon=image:18_esp/40',
            ['M8'] => 'city=revenue:0;path=a:2,b:_0,track:dual;path=a:0,b:_0,track:dual;label=80;icon=image:18_esp/40',
            %w[E16 E14 F17] => 'path=a:0,b:3,track:dual',
            %w[F15] => 'path=a:0,b:4,track:dual',
            %w[G14 H13 L11] => 'path=a:1,b:4,track:dual',
            %w[I14 J13] => 'path=a:1,b:4,track:dual,lanes:2',
            ['H15'] => 'path=a:0,b:4,b_lane:2.1,track:dual;path=a:5,b:4,b_lane:2.0,track:dual',
            ['K12'] => 'path=a:1,b:3,a_lane:2.0,track:dual;path=a:1,b:4,a_lane:2.1,track:dual',
            ['M10'] => 'path=a:1,b:3,track:dual',

          },
        }.freeze
      end
    end
  end
end
