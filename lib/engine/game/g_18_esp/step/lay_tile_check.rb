# frozen_string_literal: true

module LayTileCheck
  def potential_tiles(entity, hex)
    corp = entity.corporation? ? entity : entity.owner
    tiles = selected_tiles(entity, hex).uniq(&:name)
      .select { |t| @game.upgrades_to?(hex.tile, t) }
      .reject(&:blocks_lay)

    tiles = tiles.reject { |tile| tile.city_towns.empty? && tile.color != :yellow } if narrow_only?(entity)
    unless @game.north_hex?(hex)
      tiles = tiles.reject do |tile|
        tile.paths.any? do |path|
          path.track == :narrow || path.track == :dual
        end
      end
    end
    if @game.north_hex?(hex) && narrow_only?(entity)
      tiles = tiles.reject do |tile|
        tile.paths.any? do |path|
          path.track == :broad
        end
      end
    end

    unless @game.north_corp?(corp)
      tiles = tiles.reject do |tile|
        tile.paths.all? do |path|
          path.track == :narrow
        end
      end
    end
    tiles
  end

  def selected_tiles(entity, hex)
    colors = potential_tile_colors(entity, hex)
    @game.tiles.select do |tile|
      @game.tile_valid_for_phase?(tile, hex: hex,
                                        phase_color_cache: colors) && tile_valid_for_entity(entity, tile)
    end
  end

  def tile_valid_for_entity(entity, tile)
    narrow_only?(entity) ? tile.paths.any? { |p| p.track == :narrow } : true
  end

  def narrow_only?(entity)
    corp = entity.corporation? ? entity : entity.owner
    @game.north_corp?(corp) && !corp.interchange?
  end

  def legal_tile_rotation?(entity, hex, tile)
    legal = super
    legal &&= !mountain_pass_exit(hex, tile) unless can_open_mountain_pass?(entity)
    legal && matching_track_type(entity, hex, tile)
  end

  def can_open_mountain_pass?(entity)
    corp = entity.corporation? ? entity : entity.owner
    corp.type != :minor && @game.can_build_mountain_pass
  end

  def mountain_pass_exit(hex, tile)
    return false unless @game.mountain_pass_access?(hex)

    new_exits = tile.exits - hex.tile.exits

    new_exits.find do |exit|
      neighbor = hex.neighbors[exit]
      ntile = neighbor&.tile
      next false unless ntile
      next false unless @game.mountain_pass?(ntile.hex)

      ntile.exits.any? { |e| e == Hex.invert(exit) }
    end
  end

  def matching_track_type(entity, hex, tile)
    corp = entity.corporation? ? entity : entity.owner
    graph = @game.graph_for_entity(corp)
    connection_directions = graph.connected_hexes(corp).find { |k, _| k.id == hex.id }[1]
    connection_directions.each do |dir|
      connecting_path = tile.paths.find { |p| p.exits.include?(dir) }
      next unless connecting_path

      neighboring_tile = hex.neighbors[dir].tile
      neighboring_path = neighboring_tile.paths.find { |p| p.exits.include?(Engine::Hex.invert(dir)) }
      return false if neighboring_path && !connecting_path.tracks_match?(neighboring_path, dual_ok: true)
    end
    true
  end
end
