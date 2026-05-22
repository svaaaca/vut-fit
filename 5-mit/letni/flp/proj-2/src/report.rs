// ============================================================
// dungeon-scribe — report generation
//
// You must implement the function body below.
// ============================================================

use crate::{model::DungeonMap, reachable_floor_size, Tile};

/// Generates a human-readable summary report for the given map.
///
/// # Required output format
///
/// ```text
/// === Dungeon Report ===
/// Dimensions: 10 x 8
/// Tiles:
///   Wall:          26
///   Floor:         38
///   PlayerStart:    1
///   Enemy:          3
///   Treasure:       2
///   Exit:           1
/// Validation: OK
/// Reachable floor from player: 42
/// ```
///
/// If validation fails:
///
/// ```text
/// Validation: FAILED
///   - Missing PlayerStart
///   - No Exit found
/// ```
///
/// # Rules
///
/// - **Dimensions** — `width x height` (columns × rows).
/// - **Tiles section** — list only tile types present in the map (count ≥ 1),
///   in this canonical order:
///   `Wall`, `Floor`, `PlayerStart`, `Enemy`, `Treasure`, `Exit`, `Door`, `Trap`.
/// - **Tile count alignment** — right-align the count in a field of width 4.
///   Use the format string `{:>4}` (see the Tips section of the assignment).
/// - **Validation** — call `self.validate()`. Print `OK` on success, or
///   `FAILED` followed by one line per error (two-space indent, dash prefix).
/// - **Reachable floor** — call `reachable_floor_size` with the `PlayerStart`
///   position as `start`. If there is no `PlayerStart`, write `0`.
/// - **Line endings** — every line ends with exactly one `\n`. There is no
///   trailing blank line after the last line.
///
/// # Hint
///
/// `format!()` supports alignment: `format!("  {:14}{:>4}", label, count)`.
/// The tile label widths in the example above are not a coincidence —
/// `"PlayerStart:"` is the longest label (12 chars + `:`). Pad all labels
/// to the same width for alignment.
pub fn generate_report(map: &DungeonMap) -> String {
    let mut report = String::new();

    // header and dimensions (width x height)
    report.push_str("=== Dungeon Report ===\n");
    report.push_str(&format!("Dimensions: {} x {}\n", map.width(), map.height()));

    // tiles section
    report.push_str("Tiles:\n");
    let counts = map.count_tiles();
    let order = [
        Tile::Wall,
        Tile::Floor,
        Tile::PlayerStart,
        Tile::Enemy,
        Tile::Treasure,
        Tile::Exit,
        Tile::Door,
        Tile::Trap,
    ];

    for tile in order {
        if let Some(&count) = counts.get(&tile) {
            // each label ends with a colon (:)
            let label = format!("{:?}:", tile);

            // indent by two spaces, label aligned to 13 chars, count to four chars
            report.push_str(&format!("  {:13}{:>4}\n", label, count));
        }
    }

    // validation
    match map.validate() {
        Ok(_) => report.push_str("Validation: OK\n"),
        Err(errors) => {
            report.push_str("Validation: FAILED\n");
            for error in errors {
                // format: two spaces, hyphen (-), one space, error decription
                report.push_str(&format!("  - {}\n", error));
            }
        }
    }

    // reachable floor
    let player_starts = map.find_all(Tile::PlayerStart);
    let reachable = if player_starts.len() == 1 {
        reachable_floor_size(map, player_starts[0])
    } else {
        0
    };

    report.push_str(&format!("Reachable floor from player: {}\n", reachable));

    // no trailing blank line after the last line
    report.trim_end_matches("\n").to_string()
}

// ── Unit tests ────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;
    use crate::model::DungeonMap;

    #[test]
    fn report_starts_with_header() {
        let map = DungeonMap::parse("##\n#@\n##").unwrap();
        let report = generate_report(&map);
        assert!(report.starts_with("=== Dungeon Report ===\n"));
    }

    #[test]
    fn report_has_formatting_alignment() {
        let map = DungeonMap::parse("@.X").unwrap();
        let report = generate_report(&map);
        assert!(report.contains("  PlayerStart:    1\n"));
    }
}
