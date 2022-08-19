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
          end

          def round_state
            super.merge({
                          mea_hex: nil,
                        })
          end

          def convert_to_train(company)
            return unless company

            owner = company.owner
            @game.buy_train(owner, @game.f_train, :free)
            close!(company, owner)
            @log << "#{company.name} closes and is converted to a Freight train"
          end

          def close!(company, owner)
            owner.companies.delete(company)
            company.owner = nil
          end

          def lay_tile(action, extra_cost: 0, entity: nil, spender: nil)
            tile = action.tile
            tile.add_temp_halt('halt')
            super
          end
        end
      end
    end
  end
end
