# frozen_string_literal: true

require_relative 'base'

module Engine
  module Action
    class SpecialBuy < Base
      attr_reader :entity, :item, :owner

      def initialize(entity, item:)
        super(entity)
        @item = item
      end

      def self.h_to_args(h, _game)
        {
          item: Item.new(description: h['description'], cost: h['cost'], owner: h['owner']),
        }
      end

      def args_to_h
        {
          'description' => item.description,
          'cost' => item.cost,
          'owner' => item.owner,
        }
      end
    end
  end
end
