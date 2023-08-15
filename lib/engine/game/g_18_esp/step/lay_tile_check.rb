# frozen_string_literal: true

module LayTileCheck
  def potential_tiles(entity, hex)
    corp = entity.corporation? ? entity : entity.owner
    tiles = selected_tiles(entity, hex).uniq(&:name)
      .select { |t| @game.upgrades_to?(hex.tile, t) }
      .reject(&:blocks_lay)

    unless @game.north_hex?(hex)
      tiles = tiles.reject do |tile|
        tile.paths.any? do |path|
          path.track == :narrow || path.track == :dual
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
    @game.north_corp?(corp) && !(corp.interchange? && hex_reached_by_broad(corp, hex))
  end

  def hex_reached_by_broad(entity, hex)
    @game.broad_graph.connected_hexes(entity).include?(hex)
  end

  def legal_tile_rotation?(entity, hex, tile)
    legal = hex.tile.towns.empty?(&:halt?) ?  super : halt_upgrade_legal_rotation?(entity, hex, tile)
    mount_pass_exit = mountain_pass_exit(hex, tile)
    legal &&= !(@game.pajares_broad? && hex.id == 'E10' && tile_lay_into_pass(hex, tile, mount_pass_exit) == :narrow)
    legal
  end

  def halt_upgrade_legal_rotation?(entity_or_entities, hex, tile)
    # entity_or_entities is an array when combining private company abilities
    entities = Array(entity_or_entities)
    entity, *_combo_entities = entities

    return false unless @game.legal_tile_rotation?(entity, hex, tile)

    old_ctedges = hex.tile.city_town_edges

    new_paths = tile.paths
    new_exits = tile.exits
    new_ctedges = tile.city_town_edges
    extra_cities = [0, new_ctedges.size - old_ctedges.size].max
    multi_city_upgrade = tile.cities.size > 1 && hex.tile.cities.size > 1
    new_exits.all? { |edge| hex.neighbors[edge] } &&
      !(new_exits & hex_neighbors(entity, hex)).empty? &&
      new_paths.any? { |p| old_ctedges.flatten.empty? || (p.exits - old_ctedges.flatten).empty? } &&
      # Count how many cities on the new tile that aren't included by any of the old tile.
      # Make sure this isn't more than the number of new cities added.
      # 1836jr30 D6 -> 54 adds more cities
      extra_cities >= new_ctedges.count { |newct| old_ctedges.all? { |oldct| (newct & oldct).none? } } &&
      # 1867: Does every old city correspond to exactly one new city?
      (!multi_city_upgrade || old_ctedges.all? { |oldct| new_ctedges.one? { |newct| (oldct & newct) == oldct } })
  end

  def tile_lay_into_pass(_hex, tile, mount_pass_exit)
    return nil unless mount_pass_exit

    connecting_path = tile.paths.find { |p| p.exits.include?(mount_pass_exit) }
    return nil unless connecting_path

    connecting_path.track
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
