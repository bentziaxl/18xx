# frozen_string_literal: true

require_relative '../../stock_market'

module Engine
  module Game
    module G18ESP
      class StockMarket < Engine::StockMarket
        def move_right(corporation)
          return move_up(corporation) if corporation.share_price.types.include?(:up_arrow)

          super
        end
      end
    end
  end
end
