# frozen_string_literal: true

require_relative '../g_1846/game'
require_relative 'entities'
require_relative 'map'
require_relative 'meta'
require_relative 'step/buy_sell_par_shares'
require_relative '../stubs_are_restricted'

module Engine
  module Game
    module G18BB
      class Game < G1846::Game
        include_meta(G18BB::Meta)
        include Entities
        include Map
      end
    end
  end
end
