# frozen_string_literal: true

module LayTileCheck
  def tracker_available_hex(entity, hex)
    corp = entity.corporation? ? entity : @game.current_entity
    return nil if corp.type == :minor && !hex.tile.cities.empty? && hex != corp.tokens.first.hex

    connected = hex_neighbors(corp, hex)
    return nil unless connected

    tile_lay = get_tile_lay(corp)
    return nil unless tile_lay

    color = hex.tile.color
    return nil if color == :white && !tile_lay[:lay]
    return nil if color != :white && !tile_lay[:upgrade]
    return nil if color != :white && tile_lay[:cannot_reuse_same_hex] && @round.laid_hexes.include?(hex)
    return nil if ability_blocking_hex(corp, hex)

    connected
  end

  def potential_tiles(entity, hex)
    corp = entity.corporation? ? entity : @game.current_entity
    tiles = super
    tiles.reject! { |t| t.cities.sum(&:normal_slots) == 1 } if corp.type == :minor

    track_to_reject = corp.type == :minor ? :broad : :narrow
    tiles.reject! do |tile|
      track_types = tile.paths.map(&:track).uniq
      if corp.type == :minor
        if hex == corp.tokens.first.hex
          track_types.size == 1 && track_types.first == track_to_reject
        else
          tile.cities.size > 1 || track_types.first == track_to_reject
        end
      else
        track_types.size == 1 && track_types.first == track_to_reject
      end
    end

    tiles
  end
end
