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

        GREEN_GROUP = %w[C&O ERIE PRR B&O IC].freeze
        MINORS_GROUP = [
          'Big 4 (Minor)',
          'Nashville and Northwestern (Minor)',
          'Virginia Coal Company (Minor)',
          'Buffalo, Rochester and Pittsburgh (Minor)',
          'Cleveland, Columbus and Cincinnati (Minor)',
        ].freeze
        EXCLUSION_MAP = {
          'BRP' => 'Lake Shore Line',
          'VCC' => 'Tunnel Blasting Company',
          'N&N' => 'Bridging Company',
          'CCC' => 'Ohio & Indiana',
        }.freeze
        LEFTOVER_GROUP = [
          'Bridging Company',
          'Boomtown',
          'Grain Mill Company',
          'Lake Shore Line',
          'Little Miami',
          'Louisville, Cincinnati, and Lexington Railroad',
          'Meat Packing Company',
          'Michigan Central',
          'Ohio & Indiana',
          'Oil and Gas Company',
          'Southwestern Steamboat Company',
          'Steamboat Company',
          'Tunnel Blasting Company',
        ]

        ABILITY_ICONS = G1846::Game::ABILITY_ICONS.merge(
          SSC: 'port-orange'
        ).freeze

        def setup
          @turn = setup_turn
          @second_tokens_in_green = {}

          # When creating a game the game will not have enough to start
          unless (player_count = @players.size).between?(*self.class::PLAYER_RANGE)
            raise GameError, "#{self.class::GAME_TITLE} does not support #{player_count} players"
          end

          corporation_removal_groups.each do |group|
            remove_from_group!(group, @corporations) do |corporation|
              place_home_token(corporation)
              ability_with_icons = corporation.abilities.find { |ability| ability.type == 'tile_lay' }
              remove_icons(ability_with_icons.hexes, self.class::ABILITY_ICONS[corporation.id]) if ability_with_icons
              abilities(corporation, :reservation) do |ability|
                corporation.remove_ability(ability)
              end
              place_second_token(corporation, **place_second_token_kwargs(corporation))
            end
          end

          remove_from_group!(minors_group, @companies) do |company|
            minor_to_close = @minors.find { |m| m.id == company.id }
            minor_to_close.close!
            @minors.delete(minor_to_close)
            company.close!
            @round.active_step.companies.delete(company)
          end

          @minors.each do |m|
            removal = exculsion_map[m.id]
            next unless removal

            @log << "Removing #{removal}"
            company = @companies.find { |c| c.name == removal }
            ability_with_icons = company.abilities.find { |ability| ability.type == 'tile_lay' }
            remove_icons(ability_with_icons.hexes, self.class::ABILITY_ICONS[company.id]) if ability_with_icons
            company.close!
            @round.active_step.companies.delete(company)
            @companies.delete(company)
            leftover_group.delete(removal)
          end

          remove_from_group!(leftover_group, @companies) do |company|
            ability_with_icons = company.abilities.find { |ability| ability.type == 'assign_hexes' || ability.type == 'tile_lay' }
            remove_icons(ability_with_icons.hexes, self.class::ABILITY_ICONS[company.id]) if ability_with_icons
            company.close!
            @round.active_step.companies.delete(company)
          end

          @log << "Privates in the game: #{@companies.reject { |c| c.name.include?('Pass') }.map(&:name).sort.join(', ')}"
          @log << "Corporations in the game: #{@corporations.map(&:name).sort.join(', ')}"

          @cert_limit = init_cert_limit

          setup_company_price_up_to_face

          @draft_finished = false

          @minors.each do |minor|
            train = @depot.upcoming[0]
            train.buyable = false
            buy_train(minor, train, :free)
            hex = hex_by_id(minor.coordinates)
            token_city = hex&.tile&.cities&.first
            token_city&.place_token(minor, minor.next_token, free: true)
          end

          @last_action = nil
        end

        def corporation_removal_groups
          [GREEN_GROUP]
        end

        def minors_group
          @minors_group ||= self.class::MINORS_GROUP
        end

        def exculsion_map
          @exculsion_map ||= self.class::EXCLUSION_MAP
        end

        def leftover_group
          @leftover_group ||= self.class::LEFTOVER_GROUP
        end

        def num_removals(group)
          num =
            case group
            when MINORS_GROUP
              case @players.size
              when 6
                3
              when 5, 4, 3
                4
              end
            when LEFTOVER_GROUP
              case @players.size
              when 6
                LEFTOVER_GROUP.size - 7
              when 5
                LEFTOVER_GROUP.size - 6
              when 4
                LEFTOVER_GROUP.size - 4
              when 3
                LEFTOVER_GROUP.size - 2
              end
            else
              case @players.size
              when 6, 5
                0
              when 4
                1
              when 3
                3
              end
            end

          # handle special CCC case.
          num -= 1 if group == LEFTOVER_GROUP && @companies.any? { |c| c.id == 'CCC' }
          num
        end
      end
    end
  end
end
