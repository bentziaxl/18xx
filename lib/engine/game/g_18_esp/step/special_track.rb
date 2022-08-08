# frozen_string_literal: true

require_relative '../../../step/special_track'

module Engine
  module Game
    module G18ESP
      module Step
        class SpecialTrack < Engine::Step::SpecialTrack
          def process_lay_tile(action)
            super
            @round.mea_hex = action.hex
            convert_to_train(action.entity)
            @log << "#{action.entity.name} closes and is converted to a 2H train"
          end

          def round_state
            super.merge({
                          mea_hex: nil,
                        })
          end


          def convert_to_train(company)
            @owner = company.owner
            @owner.trains << @game.f_train
            close!(company, @owner)
            @log << "#{company.name} closes and is converted to a Freight train"
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
