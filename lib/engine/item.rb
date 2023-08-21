# frozen_string_literal: true

module Engine
  class Item
    attr_accessor :description, :cost, :owner

    def initialize(description:, cost:, owner:)
      @description = description || ''
      @cost = cost || 0
      @owner = owner || nil
    end

    def ==(other)
      @description == other.description && @cost == other.cost && owner == other.owner
    end
  end
end
