# frozen_string_literal: true

require_relative '../../../step/token'

module Engine
  module Game
    module G18Cuba
      module Step
        class Token < Engine::Step::Token
          include SkipFc
        end
      end
    end
  end
end
