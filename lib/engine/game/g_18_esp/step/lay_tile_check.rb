# frozen_string_literal: true

module LayTileCheck
  def potential_tiles(entity, hex)
    corp = entity.corporation? ? entity : entity.owner
    tiles = selected_tiles(entity, hex).uniq(&:name)
      .select { |t| @game.upgrades_to?(hex.tile, t) }
      .reject(&:blocks_lay)

    if @game.mine_hex?(hex)
      tiles = tiles.reject do |tile|
        tile.city_towns.empty? && tile.color != :yellow
      end
    end
    unless @game.north_hex?(hex)
      tiles = tiles.reject do |tile|
        tile.paths.any? do |path|
          path.track == :narrow || path.track == :dual
        end
      end
    end
    if @game.north_hex?(hex) && narrow_only?(entity, hex)
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
                                        phase_color_cache: colors) && tile_valid_for_entity(entity, tile, hex)
    end
  end

  def tile_valid_for_entity(entity, tile, hex)
    narrow_only?(entity, hex) ? tile.paths.any? { |p| p.track == :narrow || p.track == :dual } : true
  end

  def narrow_only?(entity, hex)
    corp = entity.corporation? ? entity : entity.owner
    @game.north_corp?(corp) && !(corp.interchange? && hex_reached_by_broad(entity, hex))
  end

  def hex_reached_by_broad(entity, hex)
    @game.north_corp_broad_graph.reachable_hexes(entity).include?(hex)
  end

  def legal_tile_rotation?(entity, hex, tile)
    legal = super
    mount_pass_exit = mountain_pass_exit(hex, tile)
    legal &&= !mount_pass_exit unless can_open_mountain_pass?(entity)
    legal &&= !(@game.pajares_broad? && hex.id == 'E10' && tile_lay_into_pass(hex, tile, mount_pass_exit) == :narrow)
    legal && matching_track_type(entity, hex, tile)
  end

  def can_open_mountain_pass?(entity)
    corp = entity.corporation? ? entity : entity.owner
    corp.type != :minor && @game.can_build_mountain_pass
  end

  def tile_lay_into_pass(_hex, tile, mount_pass_exit)
    return nil unless mount_pass_exit

    connecting_path = tile.paths.find { |p| p.exits.include?(mount_pass_exit) }
    return nil unless connecting_path

    connecting_path.track
  end

  def mountain_pass_exit(hex, tile)
    return false unless @game.mountain_pass_access_incl_south?(hex)

    new_exits = tile.exits - hex.tile.exits

    new_exits.find do |exit|
      neighbor = hex.neighbors[exit]
      ntile = neighbor&.tile
      next false unless ntile
      next false unless @game.mountain_pass?(ntile.hex)

      ntile.exits.any? { |e| e == Engine::Hex.invert(exit) }
    end
  end

  def matching_track_type(_entity, hex, tile)
    # All tile exits must match neighboring tiles
    tile.exits.each do |dir|
      next unless (connecting_path = tile.paths.find { |p| p.exits.include?(dir) })
      next unless (neighboring_tile = hex.neighbors[dir]&.tile)

      neighboring_path = neighboring_tile.paths.find { |p| p.exits.include?(Engine::Hex.invert(dir)) }
      return false if neighboring_path && !connecting_path.tracks_match?(neighboring_path, dual_ok: true)
    end
    true
  end
end