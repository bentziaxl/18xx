# frozen_string_literal: true

module Engine
  module Game
    module G18ESP
      module Map
        MINE_HEXES = %w[C5 C9 E9 E11 E19 G9 H6 I7 C23 G21 D18 D32 E31 H30 I23 D8 E7 B30 F30 F32 I21].freeze
        LAYOUT = :flat
        TILES = {
          '3' => 5,
          '72' => 5,
          '4' => 6,
          '74' => 6,
          '5' => 5,
          '75' => 5,
          '6' => 5,
          '76' => 5,
          '7' => 5,
          '77' => 5,
          '8' => 15,
          '78' => 15,
          '9' => 15,
          '79' => 15,
          '57' => 5,
          '956' => 5,
          '58' => 6,
          '73' => 6,
          '201' => 2,
          'L80' => {
            'count' => 2,
            'color' => 'yellow',
            'code' =>
            'city=revenue:30;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow;label=Y',
          },
          '202' => 2,
          'L81' => {
            'count' => 2,
            'color' => 'yellow',
            'code' =>
            'city=revenue:30;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;label=Y',
          },
          '621' => 2,
          'L82' => {
            'count' => 2,
            'color' => 'yellow',
            'code' =>
            'city=revenue:30;path=a:0,b:_0,track:narrow;path=a:3,b:_0,track:narrow;label=Y',
          },
          '235' => 3,
          'L135' => {
            'count' => 3,
            'color' => 'yellow',
            'code' =>
            'city=revenue:30;city=revenue:30;path=a:0,b:_0,track:narrow;label=OO',
          },
          'L79' => {
            'count' => 1,
            'color' => 'yellow',
            'code' =>
              'town=revenue:yellow_10|brown_30;town=revenue:10;path=a:0,b:_0;path=a:3,b:_0;' \
              'path=a:5,b:_0;path=a:2,b:_1;path=a:4,b:_1',
          },

          # # greens

          # '14' => 3,
          # '15' => 3,
          '16' => 1,
          '957' => 1,
          '18' => 1,
          '959' => 1,
          '19' => 1,
          '960' => 1,
          '20' => 1,
          '961' => 1,
          '23' => 4,
          '677' => 4,
          '24' => 4,
          '678' => 4,
          '25' => 3,
          '699' => 3,
          '26' => 2,
          '692' => 2,
          '27' => 2,
          '693' => 2,
          '28' => 1,
          '694' => 1,
          '29' => 1,
          '695' => 1,
          '30' => 1,
          '708' => 1,
          '31' => 1,
          '709' => 1,
          '87' => 2,
          '116' => 2,
          '88' => 2,
          '89' => 2,
          '204' => 5,
          'A5' => {
            'count' => 5,
            'color' => 'green',
            'code' =>
              'town=revenue:10;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
              'path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow',
          },
          '8858' => 1,
          'L136' => {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40;city=revenue:40;path=a:0,b:_0,track:narrow;path=a:_0,b:2,track:narrow'\
            ';path=a:1,b:_1,track:narrow;path=a:_1,b:3,track:narrow;label=OO',
          },
          '8859' => 1,
          'L137' => {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40;city=revenue:40;path=a:0,b:_0,track:narrow;path=a:_0,b:3,track:narrow'\
            ';path=a:2,b:_1,track:narrow;path=a:_1,b:5,track:narrow;label=OO',
          },
          '8860' => 1,
          'L138' => {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40;city=revenue:40;path=a:1,b:_0,track:narrow;path=a:_0,b:5,track:narrow'\
            ';path=a:2,b:_1,track:narrow;path=a:_1,b:4,track:narrow;label=OO',
          },
          '8863' => 1,
          'L139' => {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40;city=revenue:40;path=a:0,b:_0,track:narrow;path=a:_0,b:1,track:narrow'\
            ';path=a:2,b:_1,track:narrow;path=a:_1,b:5,track:narrow;label=OO',
          },
          '8864' => 1,
          'L140' => {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40;city=revenue:40;path=a:1,b:_0,track:narrow;path=a:_0,b:5,track:narrow'\
            ';path=a:2,b:_1,track:narrow;path=a:_1,b:3,track:narrow;label=OO',
          },
          '8865' => 1,
          'L141' => {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40;city=revenue:40;path=a:1,b:_0,track:narrow;path=a:_0,b:5,track:narrow'\
            ';path=a:3,b:_1,track:narrow;path=a:_1,b:4,track:narrow;label=OO',
          },
          '14' => 4,
          'L116' => {
            'count' => 4,
            'color' => 'green',
            'code' =>
            'city=revenue:30,slots:2;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow'\
            ';path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow',
          },
          '15' => 4,
          'L117' => {
            'count' => 4,
            'color' => 'green',
            'code' =>
            'city=revenue:30,slots:2;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow'\
            ';path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:narrow',
          },
          '619' => 4,
          'L118' => {
            'count' => 4,
            'color' => 'green',
            'code' =>
            'city=revenue:30,slots:2;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow'\
            ';path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow',
          },
          '207' => 2,
          'L114' => {
            'count' => 2,
            'color' => 'green',
            'code' =>
            'city=revenue:40,slots:2;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow'\
            ';path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:narrow;label=Y',
          },
          '208' => 1,
          'L113' => {
            'count' => 1,
            'color' => 'green',
            'code' =>
            'city=revenue:40,slots:2;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow'\
            ';path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow;label=Y',
          },
          '622' => 2,
          'L115' => {
            'count' => 2,
            'color' => 'green',
            'code' =>
            'city=revenue:40,slots:2;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow'\
            ';path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow;label=Y',
          },
          'L83' => {
            'count' => 1,
            'color' => 'green',
            'code' => 'city=revenue:60;city=revenue:60;city=revenue:60;path=a:0,b:_0;path=a:1,b:_0;' \
                      'path=a:2,b:_1;path=a:4,b:_2;path=a:0,b:_2;label=M',
          },
          'L84' => {
            'count' => 1,
            'color' => 'green',
            'code' => 'city=revenue:50,slots:2;path=a:1,b:_0;path=a:2,b:_0;path=a:5,b:_0;path=a:4,b:_0;label=B',
          },

          # # browns
          '39' => 2,
          '647' => 2,
          '40' => 2,
          '646' => 2,
          '41' => 2,
          '648' => 2,
          '42' => 2,
          '649' => 2,
          '43' => 2,
          'L119' => {
            'count' => 2,
            'color' => 'brown',
            'code' =>
            'path=a:0,b:3,track:narrow;path=a:0,b:2,track:narrow;path=a:1,b:3,track:narrow;path=a:1,b:2,track:narrow',
          },
          '44' => 2,
          'L120' => {
            'count' => 2,
            'color' => 'brown',
            'code' =>
            'path=a:0,b:3,track:narrow;path=a:1,b:4,track:narrow;path=a:0,b:1,track:narrow;path=a:3,b:4,track:narrow',
          },
          '45' => 2,
          'L121' => {
            'count' => 2,
            'color' => 'brown',
            'code' =>
            'path=a:0,b:3,track:narrow;path=a:2,b:4,track:narrow;path=a:0,b:4,track:narrow;path=a:2,b:3,track:narrow',
          },
          '46' => 2,
          'L122' => {
            'count' => 2,
            'color' => 'brown',
            'code' =>
            'path=a:0,b:3,track:narrow;path=a:2,b:4,track:narrow;path=a:3,b:4,track:narrow;path=a:0,b:2,track:narrow',
          },
          '47' => 2,
          'L123' => {
            'count' => 2,
            'color' => 'brown',
            'code' =>
            'path=a:0,b:3,track:narrow;path=a:1,b:4,track:narrow;path=a:1,b:3,track:narrow;path=a:0,b:4,track:narrow',
          },

          '70' => 2,
          'L124' => {
            'count' => 2,
            'color' => 'brown',
            'code' =>
            'path=a:0,b:1,track:narrow;path=a:0,b:2,track:narrow;path=a:1,b:3,track:narrow;path=a:2,b:3,track:narrow',
          },

          '216' => 2,
          'L126' => {
            'count' => 2,
            'color' => 'brown',
            'code' =>
            'city=revenue:50,slots:2;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow'\
            ';path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow;label=Y',

          },
          '611' => 8,
          'L125' => {
            'count' => 8,
            'color' => 'brown',
            'code' =>
            'city=revenue:40,slots:2;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow'\
            ';path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow',

          },

          'L127' =>
          {
            'count' => 3,
            'color' => 'brown',
            'code' => 'town=revenue:20;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
                      'path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow;path=a:5,b:_0,track:narrow',
          },

          '933' =>
          {
            'count' => 3,
            'color' => 'brown',
            'code' => 'town=revenue:20;path=a:0,b:_0;path=a:2,b:_0;path=a:3,b:_0;path=a:4,b:_0;path=a:5,b:_0',
          },
          'L85' => {
            'count' => 1,
            'color' => 'brown',
            'code' => 'city=revenue:70,slots:3;path=a:1,b:_0;path=a:2,b:_0;path=a:3,b:_0;path=a:4,b:_0;path=a:5,b:_0;label=B',
          },
          'L86' => {
            'count' => 1,
            'color' => 'brown',
            'code' => 'city=revenue:80,slots:4;path=a:0,b:_0;path=a:1,b:_0;path=a:2,b:_0;path=a:3,b:_0;'\
                      'path=a:4,b:_0;label=M',
          },

          'X7d' => {
            'count' => 2,
            'color' => 'brown',
            'code' =>
            'city=revenue:50,slots:2;path=a:0,b:_0;path=a:1,b:_0'\
            ';path=a:2,b:_0;path=a:3,b:_0;path=a:4,b:_0;label=OO',

          },
          'L131' => {
            'count' => 2,
            'color' => 'brown',
            'code' =>
            'city=revenue:50,slots:2;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow'\
            ';path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow;label=OO',

          },
          # 'L87' => {
          #   'count' => 1,
          #   'color' => 'brown',
          #   'code' => 'city=revenue:50,slots:3;path=a:0,b:_0;path=a:3,b:_0;path=a:4,b:_0;path=a:5,b:_0;'\
          #             'icon=image:anchor;label=K',
          # },
          # 'L88' => {
          #   'count' => 1,
          #   'color' => 'brown',
          #   'code' => 'city=revenue:60,slots:2;path=a:0,b:_0;path=a:3,b:_0;path=a:4,b:_0;path=a:5,b:_0;'\
          #             'icon=image:anchor;label=K',
          # },
          # 'L111' =>
          # {
          #   'count' => 3,
          #   'color' => 'brown',
          #   'code' =>
          #   'city=revenue:40,slots:2;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
          #   'path=a:4,b:_0,track:narrow;path=a:1,b:_0;path=a:3,b:_0;path=a:5,b:_0',
          # },
          # 'L112' =>
          # {
          #   'count' => 1,
          #   'color' => 'brown',
          #   'code' =>
          #   'city=revenue:50,slots:2;path=a:1,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
          #   'path=a:5,b:_0,track:narrow;path=a:0,b:_0;path=a:4,b:_0;label=Bi',
          # },
          # 'L113' =>
          # {
          #   'count' => 1,
          #   'color' => 'brown',
          #   'code' =>
          #   'city=revenue:50,slots:2;path=a:1,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
          #   'path=a:5,b:_0,track:narrow;path=a:0,b:_0;label=G',
          # },
          # 'L114' =>
          # {
          #   'count' => 1,
          #   'color' => 'brown',
          #   'code' =>
          #   'city=revenue:50,slots:2;path=a:1,b:_0,track:narrow;path=a:4,b:_0,track:narrow;'\
          #   'path=a:5,b:_0,track:narrow;path=a:0,b:_0;label=G',
          # },
          # 'L115' =>
          # {
          #   'count' => 1,
          #   'color' => 'brown',
          #   'code' =>
          #   'city=revenue:50,slots:2;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
          #   'path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow;path=a:1,b:_0;path=a:5,b:_0;label=O',
          # },
          # 'L126' =>
          # {
          #   'count' => 1,
          #   'color' => 'brown',
          #   'code' => 'town=revenue:20;path=a:0,b:_0,track:narrow;path=a:3,b:_0,track:narrow;'\
          #             'path=a:4,b:_0,track:narrow;path=a:5,b:_0,track:narrow',
          # },
          # 'L127' =>
          # {
          #   'count' => 1,
          #   'color' => 'brown',
          #   'code' => 'town=revenue:20;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
          #             'path=a:3,b:_0,track:narrow;path=a:5,b:_0,track:narrow',
          # },
          # 'L128' =>
          # {
          #   'count' => 1,
          #   'color' => 'brown',
          #   'code' =>
          #   'city=revenue:40,slots:2;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow;'\
          #   'path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:narrow;path=a:4,b:_0;path=a:5,b:_0',
          # },
          # 'L129' =>
          # {
          #   'count' => 1,
          #   'color' => 'brown',
          #   'code' =>
          #   'city=revenue:40,slots:2;path=a:0,b:_0,track:narrow;path=a:2,b:_0,track:narrow;'\
          #   'path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow;path=a:2,b:_0;path=a:5,b:_0',
          # },

          # gray

          '455' => 2,
          'L128' =>
          {
            'count' => 2,
            'color' => 'gray',
            'code' => 'city=revenue:50,slots:3;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow;'\
                      'path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:narrow;'\
                      'path=a:4,b:_0,track:narrow;path=a:5,b:_0,track:narrow',
          },

          'L129' =>
          {
            'count' => 2,
            'color' => 'gray',
            'code' => 'city=revenue:60,slots:3;path=a:0,b:_0;'\
                      'path=a:1,b:_0;path=a:3,b:_0;path=a:4,b:_0;path=a:5,b:_0;label=Y',
          },

          'L130' =>
          {
            'count' => 2,
            'color' => 'gray',
            'code' => 'city=revenue:60,slots:3;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow;'\
                      'path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow;path=a:5,b:_0,track:narrow;label=Y',
          },

          'X9b' =>
          {
            'count' => 2,
            'color' => 'gray',
            'code' => 'city=revenue:70,slots:3;path=a:0,b:_0;'\
                      'path=a:1,b:_0;path=a:3,b:_0;path=a:4,b:_0;path=a:5,b:_0;label=OO',
          },

          'L132' =>
          {
            'count' => 2,
            'color' => 'gray',
            'code' => 'city=revenue:70,slots:3;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow;'\
                      'path=a:3,b:_0,track:narrow;path=a:4,b:_0,track:narrow;path=a:5,b:_0,track:narrow;label=OO',
          },

          'L38' =>
          {
            'count' => 2,
            'color' => 'gray',
            'code' => 'town=revenue:30;path=a:0,b:_0;path=a:1,b:_0;path=a:2,b:_0;path=a:3,b:_0;path=a:4,b:_0;path=a:5,b:_0',
          },
          'L134' =>
          {
            'count' => 2,
            'color' => 'gray',
            'code' => 'town=revenue:30;path=a:0,b:_0,track:narrow;path=a:1,b:_0,track:narrow;'\
                      'path=a:2,b:_0,track:narrow;path=a:3,b:_0,track:narrow;'\
                      'path=a:4,b:_0,track:narrow;path=a:5,b:_0,track:narrow',
          },
          'L87' => {
            'count' => 1,
            'color' => 'gray',
            'code' => 'city=revenue:90,slots:3;path=a:1,b:_0;path=a:2,b:_0;path=a:3,b:_0;path=a:4,b:_0;label=B',
          },
          'L88' => {
            'count' => 1,
            'color' => 'gray',
            'code' => 'city=revenue:100,slots:4;path=a:0,b:_0;path=a:1,b:_0;path=a:2,b:_0;path=a:3,b:_0;'\
                      'path=a:4,b:_0;label=M',
          },

          'L133' => {
            'count' => 1,
            'color' => 'blue',
            'code' => 'offboard=revenue:40;icon=image:anchor;path=a:0,b:_0',
          },

        }.freeze

        TILE_GROUPS = [
          %w[3 72],
          %w[4 74],
          %w[5 75],
          %w[6 76],
          %w[7 77],
          %w[8 78],
          %w[9 79],
          %w[57 956],
          %w[58 73],
          %w[201 L80],
          %w[202 L81],
          %w[621 L82],
          %w[235 L135],
          %w[L79],

          %w[16 957],
          %w[18 959],
          %w[19 960],
          %w[20 961],
          %w[23 677],
          %w[24 678],
          %w[25 699],
          %w[26 692],
          %w[27 693],
          %w[28 694],
          %w[29 695],
          %w[30 708],
          %w[31 709],
          %w[87 116],
          %w[88 89],
          %w[204 A5],
          %w[8858 L136],
          %w[8859 L137],
          %w[8860 L138],
          %w[8863 L139],
          %w[8864 L140],
          %w[8865 L141],
          %w[14 L116],
          %w[15 L117],
          %w[619 L118],
          %w[207 L114],
          %w[208 L113],
          %w[622 L115],
          %w[L83],
          %w[L84],

          %w[39 647],
          %w[40 646],
          %w[41 648],
          %w[42 649],
          %w[43 L119],
          %w[45 L121],
          %w[46 L122],
          %w[47 L123],
          %w[611 L125],
          %w[216 L126],
          %w[X7d L131],
          %w[933 L127],
          %w[L85],
          %w[L86],

          %w[455 L128],
          %w[L129 L130],
          %w[X9b L132],
          %w[L38 L134],
          %w[L87],
          %w[L88],
          %w[L133],

        ].freeze

        LOCATION_NAMES = {
          'A5' => 'Galicia',
          'A9' => 'Vigo',
          'A11' => 'Portugal',
          'A3' => 'Ribadeo',
          'B4' => 'Luarca (Ḷḷuarca)',
          'B10' => 'Ponferrada',
          'D2' => 'Candás',
          'D4' => 'Avilés',
          'D6' => 'Oviedo (Uviéu)',
          'D8' => 'Mieres',
          'C3' => 'Muros de Nalón',
          'E3' => 'Gijón (Xixón)',
          'E5' => 'Sierro',
          'E7' => 'Langero (Llangréu)',
          'F4' => 'Ribadesella (Ribeseya)',
          'F6' => 'Cangas de Onis (Cangues d\'Onís)',
          'G5' => 'Llanes',
          'H4' => 'Torrelavega',
          'H8' => 'Reinosa',
          'I5' => 'Santander',
          'J4' => 'Laredo',
          'J6' => 'Balmaseda',
          'K5' => 'Bilbao (Bilbo)',
          'M5' => 'Irún (Irun)',
          'C1' => 'San Esteban de Pravia harbor',
          'E1' => 'Gijón harbor',
          'K3' => 'Bilbao harbor',
          'D12' => 'Pajares Mountain Pass',
          'H12' => 'Alar del Rey Mountain Pass',
          'J10' => 'País Vasco (Euskadi) Mountain Pass 1',
          'M8' => 'País Vasco (Euskadi) Mountain Pass 2',

          # south map
          'C21' => 'Porto',
          'B24' => 'Castelo Branco',
          'A25' => 'Lisboa',
          'A29' => 'Faro',
          'B26' => 'Badajoz',
          'B30' => 'Huelva',
          'C25' => 'Cáceres',
          'C31' => 'Sevilla',
          'C33' => 'Cádiz',
          'D18' => 'León',
          'D20' => 'Zamora',
          'D22' => 'Salamanca',
          'E19' => 'Palencia',
          'E21' => 'Valladolid',
          'E29' => 'Córdoba',
          'E33' => 'Málaga',
          'B34' => 'Cádiz harbor',
          'F18' => 'Burgos',
          'F24' => 'Madrid',
          'F26' => 'Toledo and Aranjuez',
          'F28' => 'Ciudad Real',
          'F30' => 'Linares',
          'F32' => 'Granada',
          'F34' => 'Málaga harbor',
          'G17' => 'Vitoria',
          'G23' => 'Guadalajara',
          'G27' => 'Alcázar de San Juan',
          'H16' => 'San Sebastián (Donostia)',
          'H28' => 'Albacete',
          'H32' => 'Almería',
          'I15' => 'Bayonne',
          'I17' => 'Pamplona (Iruña)',
          'I21' => 'Calatayud',
          'I29' => 'Murcia',
          'J20' => 'Zaragoza',
          'J24' => 'Teruel',
          'J28' => 'Alicante',
          'J30' => 'Cartagena',
          'J32' => 'Cartagena harbor',
          'K15' => 'Paris',
          'K19' => 'Lérida (Lleida)',
          'K23' => 'Castellón (Castelló)',
          'K25' => 'Valencia (València)',
          'L16' => 'Toulouse',
          'L22' => 'Tarragona',
          'L24' => 'Valencia harbor',
          'M21' => 'Barcelona',
          'N18' => 'Perpignan',
          'N20' => 'Gerona (Girona)',
          'N22' => 'Barcelona harbor',

        }.freeze

        HEXES = {
          blue: {
            %w[C1] => 'offboard=revenue:yellow_40|green_30|brown_20|gray_20',
            %w[E1 K3] => 'offboard=revenue:yellow_20|green_30|brown_40|gray_50',
            %w[L24] => 'offboard=revenue:yellow_20|green_30|brown_50|gray_60',
            %w[J32] => 'offboard=revenue:yellow_40|green_30|brown_30|gray_40',
            %w[F34] => 'offboard=revenue:yellow_20|green_30|brown_30|gray_40',
            %w[B34] => 'offboard=revenue:yellow_20|green_30|brown_30|gray_40',
            %w[N22] => 'offboard=revenue:yellow_20|green_30|brown_50|gray_60',
          },
          red: {
            %w[A5] =>
                     'offboard=revenue:yellow_10|green_30|brown_40|gray_50;'\
                     'path=a:3,b:_0,track:dual;path=a:4,b:_0,track:dual;path=a:5,b:_0,track:dual;label=W',
            ['A9'] => 'offboard=revenue:yellow_20|green_30|brown_40|gray_50;'\
                      'path=a:4,b:_0,track:dual;path=a:5,b:_0,track:dual;label=W',
            %w[A11] =>
                     'offboard=revenue:yellow_20|green_30|brown_40|gray_50,hide:1;path=a:4,b:_0,track:dual;label=W',
            ['M5'] =>
                   'offboard=revenue:yellow_20|green_30|brown_50|gray_60;'\
                   'path=a:1,b:_0,track:dual;path=a:2,b:_0,track:dual;label=E',
            ['C21'] => 'offboard=revenue:yellow_20|green_30|brown_50|gray_60;'\
                       'path=a:4,b:_0,track:dual;path=a:5,b:_0,track:dual;border=edge:2;label=W',
            ['B24'] => 'offboard=revenue:yellow_10|green_20|brown_40|gray_50;path=a:0,b:_0,track:dual;'\
                       'path=a:4,b:_0,track:dual;path=a:5,b:_0,track:dual;label=W',
            %w[A25 A29] => 'offboard=revenue:yellow_20|green_30|brown_50|gray_50,hide:1;path=a:5,b:_0,track:dual;label=W',
            ['A27'] => 'offboard=revenue:yellow_20|green_30|brown_50|gray_60;'\
                       'path=a:4,b:_0,track:dual;path=a:5,b:_0,track:dual;label=W',
            ['A31'] => 'offboard=revenue:yellow_10|green_20|brown_40|gray_50;path=a:4,b:_0,track:dual;label=W',
            %w[M17
               I15] => 'offboard=revenue:yellow_20|green_30|brown_50|gray_60;'\
                       'path=a:0,b:_0,track:dual;path=a:1,b:_0,track:dual;label=E',
            %w[N18] => 'offboard=revenue:yellow_20|green_30|brown_40|gray_50;'\
                       'path=a:0,b:_0,track:dual;path=a:1,b:_0,track:dual;label=E',
            %w[J16] => 'offboard=revenue:yellow_30|green_50|brown_60|gray_80'\
                       ';path=a:0,b:_0,track:dual;path=a:5,b:_0,track:dual;label=E',
            %w[K15] => 'offboard=revenue:yellow_20|green_30|brown_40|gray_50,hide:1;path=a:0,b:_0,track:dual;label=E',
            %w[L16] => 'offboard=revenue:yellow_20|green_30|brown_50|gray_60,hide:1;path=a:0,b:_0,track:dual;label=E',
          },
          yellow: {
            ['K5'] => 'city=revenue:30;path=a:1,b:_0,track:narrow;path=a:2,b:_0,track:narrow;label=Y;' \
                      'icon=image:18_esp/FdSB,sticky:1;icon=image:18_esp/FdLR,sticky:1;'\
                      'frame=color:#35A7FF;icon=image:anchor',
            ['F24'] => 'city=revenue:30;city=revenue:30;city=revenue:30;path=a:0,b:_0;path=a:1,b:_0;' \
                       'path=a:2,b:_1;path=a:4,b:_2;path=a:0,b:_2;label=M',
            ['M21'] => 'city=revenue:30;city=revenue:30;path=a:1,b:_0;path=a:2,b:_1;label=B;'\
                       'frame=color:#35A7FF;icon=image:anchor',
          },
          white: {
            %w[B6 B8 B28 C19 D4 D34 H26 I27 I31 J26 K27 L4 L20] => '',
            %w[A3 B4 D2 H4 J4] => 'town=revenue:0',
            %w[J30] => 'town=revenue:0;frame=color:#35A7FF;icon=image:anchor',
            %w[C33] => 'town=revenue:0;frame=color:#35A7FF;icon=image:anchor',
            %w[G5] => 'town=revenue:0;icon=image:18_esp/CFEA,sticky:1;border=edge:0,type:impassable',
            %w[B10 D4 F18 F32 I5 K19 L22] => 'city=revenue:0',
            ['E3'] => 'city=revenue:0;frame=color:#35A7FF;icon=image:anchor;label=Y',
            %w[E33] => 'city=revenue:0;'\
                       'label=Y;frame=color:#35A7FF;icon=image:anchor',
            %w[K25] => 'city=revenue:0;label=Y;frame=color:#35A7FF;icon=image:anchor',
            %w[C5 C9 E9 G9 I7 C23 G21 D32 E31 I23] => 'upgrade=cost:30,terrain:mine',
            %w[H6] => 'upgrade=cost:30,terrain:mine;border=edge:1,type:impassable',
            %w[H30] => 'upgrade=cost:30,terrain:mine;border=edge:2,type:impassable',
            %w[E7] => 'town=revenue:0;upgrade=cost:30,terrain:mine;icon=image:18_esp/CFLG,sticky:1',
            %w[B26 C27] => 'city=revenue:0;upgrade=cost:20,terrain:river',
            %w[D6] => 'city=revenue:0;city=revenue:0;upgrade=cost:10,terrain:river;label=OO',
            %w[J20] => 'city=revenue:0;city=revenue:0;upgrade=cost:20,terrain:river;' \
                       'icon=image:18_esp/ZPB,sticky:1;label=OO',
            %w[C31] => 'city=revenue:0;city=revenue:0;upgrade=cost:20,terrain:river;'\
                       'icon=image:18_esp/A,sticky:1;label=OO',
            %w[E21] => 'city=revenue:0;upgrade=cost:20,terrain:river;icon=image:18_esp/N,sticky:1',
            %w[F4 F6] => 'town=revenue:0;upgrade=cost:10,terrain:river',
            %w[K21] => 'upgrade=cost:20,terrain:river',
            %w[L18 M19] => 'upgrade=cost:80,terrain:mountain',
            %w[G7] => 'upgrade=cost:40,terrain:mountain;border=edge:3,type:impassable;border=edge:4,type:impassable',
            %w[H22 H24 J22] => 'upgrade=cost:60,terrain:mountain',
            %w[E11 F8 H10 J8 K7 L6] => 'upgrade=cost:30,terrain:mountain',
            %w[G29] => 'upgrade=cost:60,terrain:mountain;border=edge:5,type:impassable',
            %w[J6] => 'town=revenue:0;upgrade=cost:30,terrain:mountain',
            %w[D10 D22 H8 H28] => 'city=revenue:0;upgrade=cost:30,terrain:mountain',
            %w[I17] => 'town=revenue:0;upgrade=cost:80,terrain:mountain',
            %w[D20] => 'town=revenue:0;upgrade=cost:10,terrain:river',
            %w[C25] => 'city=revenue:0;upgrade=cost:10,terrain:river;' \
                       'icon=image:18_esp/MCP,sticky:1',
            %w[E29] => 'city=revenue:0;upgrade=cost:10,terrain:river',
            %w[I29] => 'city=revenue:0;upgrade=cost:10,terrain:river;label=Y',
            %w[J28] => 'city=revenue:0;upgrade=cost:10,terrain:river;icon=image:18_esp/MZA,sticky:1;label=Y',
            %w[F20 D24 D26 D30 H18 I19 G25] => 'upgrade=cost:10,terrain:river',
            %w[B30 D8 D18 E19 F30 G17 I21] => 'town=revenue:0;upgrade=cost:30,terrain:mine',
            %w[C7 C11 E23 E25 F10 F22 G19 H20 I9 I25 G33] => 'upgrade=cost:40,terrain:mountain',
            %w[E5 H32 J24 K23 N20] => 'town=revenue:0;upgrade=cost:40,terrain:mountain',
            %w[G31] => 'upgrade=cost:120,terrain:mountain',
            %w[J18 K17] => 'upgrade=cost:100,terrain:mountain',
            %w[C29 D28 E27] => 'upgrade=cost:20,terrain:mountain',
            %w[G23] => 'town=revenue:0;upgrade=cost:20,terrain:mountain',
            %w[F28] => 'town=revenue:0;upgrade=cost:20,terrain:mountain;icon=image:18_esp/CRB,sticky:1',
            %w[F26] => 'town=revenue:0;town=revenue:0;upgrade=cost:20,terrain:river',

          },
          gray: {
            ['C3'] => 'town=revenue:10;path=a:1,b:_0,track:narrow;path=a:0,b:_0,track:narrow;'\
                      'path=a:5,b:_0,track:narrow;path=a:3,b:_0,track:narrow;frame=color:#35A7FF;icon=image:anchor',
            ['H16'] => 'town=revenue:yellow_20|green_30|brown_40|gray_50;path=a:0,b:_0;'\
                       'path=a:1,b:_0;path=a:2,b:_0;path=a:4,b:_0;path=a:5,b:_0',
            ['G27'] => 'city=revenue:30,slots:2;path=a:1,b:_0;path=a:2,b:_0;path=a:4,b:_0;path=a:5,b:_0',
            %w[I3] => 'offboard=revenue:0;path=a:0,b:_0,track:dual',
          },
          orange: {
            ['D12'] => 'city=revenue:0;path=a:3,b:_0,track:dual;path=a:0,b:_0,track:dual;label=120;icon=image:18_esp/60',
            ['H12'] => 'city=revenue:0;path=a:3,b:_0,track:dual;path=a:1,b:_0,track:dual;label=60;icon=image:18_esp/30',
            ['J10'] => 'city=revenue:0;path=a:3,b:_0,track:dual;path=a:0,b:_0,track:dual;label=80;icon=image:18_esp/40',
            ['L8'] => 'city=revenue:0;path=a:2,b:_0,track:dual;path=a:0,b:_0,track:dual;label=80;icon=image:18_esp/40',
            %w[D16 D14 E17] => 'path=a:0,b:3,track:dual',
            %w[E15] => 'path=a:0,b:4,track:dual',
            %w[F14 G13 K11] => 'path=a:1,b:4,track:dual',
            %w[H14 I13] => 'path=a:1,b:4,track:dual,lanes:2',
            ['G15'] => 'path=a:0,b:4,b_lane:2.1,track:dual;path=a:5,b:4,b_lane:2.0,track:dual',
            ['J12'] => 'path=a:1,b:3,a_lane:2.0,track:dual;path=a:1,b:4,a_lane:2.1,track:dual',
            ['L10'] => 'path=a:1,b:3,track:dual',

          },
        }.freeze
      end
    end
  end
end
