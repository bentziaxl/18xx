# frozen_string_literal: true

require_relative '../../../step/base'
require_relative '../../../step/passable_auction'

module Engine
  module Game
    module G18Cuba
      module Step
        class SelectionAuction < Engine::Step::SelectionAuction
          def setup
            setup_auction
            @companies = @game.commissioners
            @cheapest = @companies.first
            @auction_triggerer = current_entity
            auction_entity(@cheapest)
          end

          def round_state
            {
              companies_pending_par: [],
            }
          end

          def post_win_bid(_winner, _company)
            @round.goto_entity!(@auction_triggerer)
            entities.each(&:unpass!)
            next_entity!
            @auction_triggerer = current_entity
            auction_entity(@companies.first) unless @companies.empty?
          end

          def auction_entity(company)
            super
            @log << "#{@auction_triggerer.name} puts up #{company.name} for auction with a bid of 0"
            add_bid(Engine::Action::Bid.new(@auction_triggerer, price: 0, company: company))
            # puts("#{current_entity}")
          end

          def assign_company(company, player)
            company.value = 0
            super
          end
        end
      end
    end
  end
end
