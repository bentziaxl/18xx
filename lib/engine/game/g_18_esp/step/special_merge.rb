# frozen_string_literal: true

require_relative '../../../step/base'

module Engine
  module Game
    module G18ESP
      module Step
        class SpecialMerge < Engine::Step::Base
          def actions(entity)
            return [] if !entity.corporation? || entity != current_entity
            return [] if @game.corporations.empty? do |c|
                           c.floated? && !c.taken_over_minor && c.type != :minor && !@game.north_corp?(c)
                         end

            return ['choose'] if @merging

            %w[merge]
          end

          def merge_name(_entity = nil)
            'Aquire'
          end

          def active_entities
            @game.corporations.select { |c| c.type != :minor && !c.taken_over_minor && c.floated? && !@game.north_corp?(c) }.sort
          end

          def merger_auto_pass_entity
            current_entity
          end

          def can_merge?(entity)
            entity.corporation? &&
            entity.type != :minor &&
            !entity.taken_over_minor &&
            !mergeable_candidates(entity).empty?
          end

          def description
            return 'Choose Survivor' if @merging

            'Merge'
          end

          def process_merge(action)
            @merging = [action.entity, action.corporation]
            @log << "#{@merging.first.name} is taking over #{@merging.last.name}"
          end

          def process_choose(action)
            keep_token = (action.choice.to_s == 'map')
            @game.start_merge(action.entity, @merging.last, keep_token)
            @merging = nil
            pass!
          end

          def mergeable_type(corporation)
            "Minors that #{corporation.name} can acquire"
          end

          def setup
            @mergeable_ = {}
          end

          def mergeable_candidates(corporation)
            return [] if @game.north_corp?(corporation)

            mergables = @game.corporations.select { |c| c.type == :minor && c.floated? }
            mergables = @game.corporations.select { |c| c.type == :minor } if mergables.empty?
            mergables
          end

          def mergeable(corporation)
            mergeable_candidates(corporation)
          end

          def choice_name
            'Keep minor company token on map or charter?'
          end

          def choices
            options = {
              charter: 'Charter',
            }
            options[:map] = 'Map' if can_swap?
            options
          end

          def can_swap?
            @merging.last.tokens.first.used &&
            !special_minor_or_mz?(@merging.last) &&
            current_entity.cash >= 100
          end

          def special_minor_or_mz?(entity)
            @game.special_minor?(entity) || entity.name == 'MZ'
          end

          def show_other_players
            true
          end

          def show_other
            @merging ? @merging.last : nil
          end
        end
      end
    end
  end
end
