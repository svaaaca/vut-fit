// ============================================================
// dungeon-scribe — reachability analysis
//
// You must implement the function body below.
// You may add private helper functions.
// ============================================================

use std::collections::{HashSet, VecDeque};

use crate::model::{DungeonMap, Position};

/// Returns the number of passable tiles reachable from `start` via
/// 4-directional movement (up, down, left, right), without crossing walls.
///
/// A tile is passable if `Tile::is_passable()` returns `true` for it.
/// The starting tile itself is counted if it is passable.
///
/// # Returns
///
/// - `0` if `start` is out of bounds.
/// - `0` if the tile at `start` is not passable (i.e. is a `Wall`).
/// - Otherwise, the total number of passable tiles in the connected region
///   that contains `start`, including `start` itself.
///
/// # Implementation notes
///
/// A standard BFS or DFS is the expected approach:
/// - Use a `VecDeque<Position>` (BFS) or `Vec<Position>` (DFS) as the frontier.
/// - Use a `HashSet<Position>` to track visited positions.
/// - `Position` is `(usize, usize)` which is `Copy`, so you can push positions
///   into the queue without lifetime issues.
///
/// # Warning — usize subtraction
///
/// `Position` uses `usize`. Subtracting from `0_usize` causes a panic.
/// When generating the four neighbours of a position, guard against
/// `row == 0` and `col == 0` **before** subtracting.
pub fn reachable_floor_size(map: &DungeonMap, start: Position) -> usize {
    // checking basic limits and passability at the start
    match map.get(start) {
        Some(tile) if tile.is_passable() => tile,
        _ => return 0,
    };

    // preparation of structures
    let mut visited = HashSet::new();
    let mut queue = VecDeque::new();

    // starting at the start position
    visited.insert(start);
    queue.push_back(start);

    // BFS main loop
    while let Some((row, col)) = queue.pop_front() {
        // defining the neighbors (up, down, left, right)
        let mut neighbors = Vec::new();

        // upwards
        if row > 0 {
            neighbors.push((row - 1, col));
        }

        // downwards
        if row + 1 < map.height() {
            neighbors.push((row + 1, col));
        }

        // leftwards
        if col > 0 {
            neighbors.push((row, col - 1));
        }

        // rightwards
        if col + 1 < map.width() {
            neighbors.push((row, col + 1));
        }

        for neighbor in neighbors {
            // not yet visited
            if !visited.contains(&neighbor) {
                // walk-through tile
                if let Some(tile) = map.get(neighbor) {
                    if tile.is_passable() {
                        // marking tile as visited and adding it to the queue
                        visited.insert(neighbor);
                        queue.push_back(neighbor);
                    }
                }
            }
        }
    }

    // the number of all unique visited tiles
    visited.len()
}

// ── Unit tests ────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;
    use crate::model::DungeonMap;

    #[test]
    fn wall_start_returns_zero() {
        let map = DungeonMap::parse("###\n#@#\n###").unwrap();
        // (0, 0) is a Wall
        assert_eq!(reachable_floor_size(&map, (0, 0)), 0);
    }

    #[test]
    fn out_of_bounds_start_returns_zero() {
        let map = DungeonMap::parse("###\n#@#\n###").unwrap();
        assert_eq!(reachable_floor_size(&map, (99, 99)), 0);
    }

    #[test]
    fn reachable_region_returns_four() {
        let map = DungeonMap::parse("@.#..\n..#..\n#####\n.....").unwrap();
        assert_eq!(reachable_floor_size(&map, (0, 0)), 4);
    }

    #[test]
    fn only_starting_position_returns_one() {
        let map = DungeonMap::parse("@##\n###\n...").unwrap();
        assert_eq!(reachable_floor_size(&map, (0, 0)), 1);
    }
}
