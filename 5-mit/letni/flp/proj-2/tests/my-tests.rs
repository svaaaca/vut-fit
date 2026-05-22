// =============================================================================
// My tests — Dungeon Map Scribe
//
// Run with: cargo test --tests
// =============================================================================

use dungeon_scribe::{reachable_floor_size, DungeonMap, Tile, ValidationError};

// ── Helper constants ─────────────────────────────────────────────────────────

const MAP_CORNER_START: &str = "\
@..##\n\
...##\n\
#####\n\
##.X.\n\
##...";

// ── Accumulation of errors (IT-1) ────────────────────────────────────────────

#[test]
fn multiple_validation_errors_and_report_formatting() {
    let map = DungeonMap::parse("@@").unwrap();
    let errors = map.validate().unwrap_err();

    // verification of the validation process itself
    assert!(map.validate().is_err());

    // must contain an error for multiple starts, missing exit and floor
    assert!(errors
        .iter()
        .any(|e| matches!(e, ValidationError::MultiplePlayerStarts(_))));
    assert!(errors.contains(&ValidationError::NoExit));
    assert!(errors.contains(&ValidationError::NoFloor));

    let report = dungeon_scribe::generate_report(&map);

    // checking that errors are correctly reflected in the report
    assert!(report.contains("Validation: FAILED"));
    assert!(report.contains("  - Multiple PlayerStart"));
    assert!(report.contains("  - No Exit found"));
}

// ── Line endings and order (IT-2) ────────────────────────────────────────────

#[test]
fn windows_endings_wide_map_and_canonical_order() {
    let map = DungeonMap::parse("X.E#@T+#.E\r\n").unwrap();

    // checking the map dimensions
    assert_eq!(map.width(), 10);
    assert_eq!(map.height(), 1);

    let report = dungeon_scribe::generate_report(&map);
    let tiles = report.split("Tiles:").last().unwrap();
    let wall = tiles.find("Wall:").unwrap();
    let floor = tiles.find("Floor:").unwrap();
    let player_start = tiles.find("PlayerStart:").unwrap();
    let enemy = tiles.find("Enemy:").unwrap();
    let exit = tiles.find("Exit:").unwrap();

    // verifying of the canonical order
    assert!(wall < floor);
    assert!(floor < player_start);
    assert!(player_start < enemy);
    assert!(enemy < exit);

    // checking number alignment (width 4)
    assert!(report.contains("  Wall:           2"));
}

// ── Comprehensive accessibility (IT-3) ───────────────────────────────────────

#[test]
fn reachability_with_disconnected_regions_and_corner_start() {
    let map = DungeonMap::parse(MAP_CORNER_START).unwrap();

    // the player is at (0, 0)
    assert_eq!(map.get((0, 0)), Some(&Tile::PlayerStart));

    let reachable = reachable_floor_size(&map, (0, 0));
    let report = dungeon_scribe::generate_report(&map);

    // the only reachable area is the top-left square
    assert_eq!(reachable, 6);

    // checking the correcponding report output
    assert!(report.contains("Reachable floor from player: 6"));

    // checking that the wall start returns 0
    assert_eq!(reachable_floor_size(&map, (2, 0)), 0);
}
