# frozen_string_literal: true

module LayTileCheck
  def potential_tiles(entity, hex)
    corp = entity.corporation? ? entity : entity.owner
    tiles = selected_tiles(entity, hex).uniq(&:name)
      .select { |t| @game.upgrades_to?(hex.tile, t) }
      .reject(&:blocks_lay)

    tiles = tiles.reject { |tile| tile.city_towns.empty? && tile.color != :yellow } if @game.north_corp?(corp)
    unless @game.north_hex?(hex)
      tiles = tiles.reject do |tile|
        tile.paths.any? do |path|
          path.track == :narrow || path.track == :dual
        end
      end
    end
    if @game.north_hex?(hex) && @game.north_corp?(corp)
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
end
