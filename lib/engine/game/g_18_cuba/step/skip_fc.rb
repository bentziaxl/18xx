# frozen_string_literal: true

module Engine
  module Game
    module G18Cuba
      module SkipFc
        def actions(entity)
          return [] if @game.fc == entity

          super
        end
      end
    end
  end
end
