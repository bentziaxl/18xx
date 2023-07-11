# frozen_string_literal: true

require_relative '../../../step/special_track'

module Engine
  module Game
    module G18ESP
      module Step
        class SpecialTrack < Engine::Step::SpecialTrack
          def process_lay_tile(action)
            super
          end

          def close!(company, owner)
            owner.companies.delete(company)
            company.owner = nil
          end
        end
      end
    end
  end
end
