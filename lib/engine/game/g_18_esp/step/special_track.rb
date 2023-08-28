# frozen_string_literal: true

require_relative '../../../step/special_track'
require_relative 'lay_tile_check'

module Engine
  module Game
    module G18ESP
      module Step
        class SpecialTrack < Engine::Step::SpecialTrack
          include LayTileCheck
          def close!(company, owner)
            owner.companies.delete(company)
            company.owner = nil
          end
        end
      end
    end
  end
end
