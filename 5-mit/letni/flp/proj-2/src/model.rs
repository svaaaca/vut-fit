// ============================================================
// dungeon-scribe — DungeonMap and Position
//
// The struct definition and all method signatures are provided.
// You must implement every method body that contains `todo!()`.
//
// You may add private helper methods freely.
// Do not change any public signature.
// ============================================================

use std::collections::HashMap;

use crate::error::{ParseError, ValidationError};
use crate::tile::Tile;

/// A position in the dungeon map, represented as `(row, col)`.
///
/// Both `row` and `col` are 0-based.
pub type Position = (usize, usize);

/// A successfully parsed dungeon map.
///
/// The grid is stored as a `Vec` of rows, each row being a `Vec<Tile>`.
/// `width` is the number of columns; `height` is the number of rows.
#[derive(Debug, PartialEq)]
pub struct DungeonMap {
    tiles: Vec<Vec<Tile>>,
    width: usize,
    height: usize,
}

impl DungeonMap {
    // ── Parsing ──────────────────────────────────────────────────────────────

    /// Parse a multi-line `&str` into a `DungeonMap`.
    ///
    /// Each line of the input corresponds to one row of the map.
    /// Lines are split on `'\n'`; any trailing `'\r'` is stripped first so
    /// that both Unix (`\n`) and Windows (`\r\n`) files are accepted.
    ///
    /// # Errors
    ///
    /// - `ParseError::EmptyInput` — input has no non-empty lines.
    ///   Lines that contain only whitespace also count as empty.
    /// - `ParseError::JaggedMap` — a row has a different width from row 0.
    ///   The error carries the 0-based index of the offending row, the
    ///   expected width (from row 0), and the actual width found.
    /// - `ParseError::UnknownTile` — a character is not recognised.
    ///   The error carries the character and its `(row, col)` position.
    ///
    /// # Hint
    ///
    /// The idiomatic Rust approach is to use `lines().enumerate()` and then
    /// `chars().enumerate()` with `map` and `collect::<Result<Vec<_>, _>>()`.
    /// This pattern propagates errors naturally while building the
    /// `Vec<Vec<Tile>>`.
    pub fn parse(input: &str) -> Result<DungeonMap, ParseError> {
        let lines: Vec<&str> = input
            .lines()
            .map(|line| line.trim_end_matches('\r'))
            .filter(|line| !line.trim().is_empty())
            .collect();

        if lines.is_empty() {
            return Err(ParseError::EmptyInput);
        }

        let expected = lines[0].len();
        let mut tiles = Vec::new();

        for (row, line) in lines.into_iter().enumerate() {
            let found = line.len();

            // checking the jagged map
            if found != expected {
                return Err(ParseError::JaggedMap {
                    row,
                    expected,
                    found,
                });
            }

            // parsing individual tiles in a row
            let tile: Result<Vec<Tile>, ParseError> = line
                .chars()
                .enumerate()
                .map(|(col, c)| {
                    Tile::from_char(c).map_err(|_| {
                        // passing the correct position into an error
                        ParseError::UnknownTile { c, row, col }
                    })
                })
                .collect();

            tiles.push(tile?);
        }

        let height = tiles.len();
        Ok(DungeonMap {
            tiles,
            width: expected,
            height,
        })
    }

    // ── Accessors ─────────────────────────────────────────────────────────────

    /// Returns a reference to the tile at `pos = (row, col)`.
    ///
    /// Returns `None` if the position is out of bounds.
    /// The returned reference has the same lifetime as `&self`.
    pub fn get(&self, pos: Position) -> Option<&Tile> {
        let (row, col) = pos;
        self.tiles.get(row)?.get(col)
    }

    /// Returns the width of the map (number of columns).
    pub fn width(&self) -> usize {
        self.width
    }

    /// Returns the height of the map (number of rows).
    pub fn height(&self) -> usize {
        self.height
    }

    /// Returns an iterator over the rows of the map.
    ///
    /// Each item is a reference to one row (`&Vec<Tile>`).
    ///
    /// Note: returning `impl Iterator` from a method requires understanding
    /// that the iterator borrows from `&self`.
    pub fn rows(&self) -> impl Iterator<Item = &Vec<Tile>> {
        self.tiles.iter()
    }

    // ── Analysis ──────────────────────────────────────────────────────────────

    /// Returns a `HashMap` mapping each `Tile` variant to its count.
    ///
    /// Only tile types that appear at least once are included as keys.
    /// Absent tile types must **not** appear with a count of `0`.
    ///
    /// # Hint
    ///
    /// `self.rows().flat_map(|row| row.iter())` gives you a flat iterator
    /// over every tile in the map.
    pub fn count_tiles(&self) -> HashMap<Tile, usize> {
        let mut counts = HashMap::new();
        for tile in self.rows().flat_map(|row| row.iter()) {
            *counts.entry(*tile).or_insert(0) += 1;
        }

        counts
    }

    /// Returns all positions where `tile` appears, sorted row-first then
    /// column (i.e. in reading order).
    ///
    /// Returns an empty `Vec` if the tile does not appear in the map.
    pub fn find_all(&self, tile: Tile) -> Vec<Position> {
        let mut positions = Vec::new();
        for (row, line) in self.tiles.iter().enumerate() {
            for (col, current) in line.iter().enumerate() {
                if *current == tile {
                    positions.push((row, col));
                }
            }
        }

        positions
    }

    // ── Validation ────────────────────────────────────────────────────────────

    /// Validates the structural integrity of the map.
    ///
    /// Returns `Ok(())` if and only if all of the following hold:
    /// - Exactly one `PlayerStart` tile exists.
    /// - At least one `Exit` tile exists.
    /// - At least one `Floor` tile exists.
    ///
    /// Otherwise returns `Err(errors)` where `errors` is a `Vec` containing
    /// **every** applicable `ValidationError`.
    ///
    /// # Important
    ///
    /// Unlike most `Result`-returning functions, this one must **accumulate
    /// all errors** before returning. Do not use `?` for early return here.
    /// Build a `Vec<ValidationError>`, push to it for each failing condition,
    /// and return `Err(errors)` at the end if it is non-empty.
    pub fn validate(&self) -> Result<(), Vec<ValidationError>> {
        let mut errors = Vec::new();
        let counts = self.count_tiles();

        // checking PlayerStart with specific positions for MultiplePlayerStarts
        let player_starts = self.find_all(Tile::PlayerStart);
        if player_starts.is_empty() {
            errors.push(ValidationError::MissingPlayerStart);
        } else if player_starts.len() > 1 {
            // provide the entire list of positions
            errors.push(ValidationError::MultiplePlayerStarts(player_starts));
        }

        // checking Exit existence in the HashMap
        if !counts.contains_key(&Tile::Exit) {
            errors.push(ValidationError::NoExit);
        }

        // checking Floor existence in the HashMap
        if !counts.contains_key(&Tile::Floor) {
            errors.push(ValidationError::NoFloor);
        }

        if errors.is_empty() {
            Ok(())
        } else {
            Err(errors)
        }
    }
}

// ── Unit tests ────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_empty_input_returns_error() {
        assert!(DungeonMap::parse("").is_err());
    }

    #[test]
    fn parse_single_row_map() {
        let map = DungeonMap::parse("###").unwrap();
        assert_eq!(map.width(), 3);
        assert_eq!(map.height(), 1);
    }

    #[test]
    fn parse_valid_square_map() {
        let map = DungeonMap::parse("###\n#@.\n#EX").unwrap();
        assert_eq!(map.width(), 3);
        assert_eq!(map.height(), 3);
        assert_eq!(map.get((1, 1)), Some(&Tile::PlayerStart));
    }

    #[test]
    fn parse_jagged_map_returns_error() {
        let map = DungeonMap::parse("###\n##");
        assert!(matches!(
            map,
            Err(ParseError::JaggedMap {
                row: 1,
                expected: 3,
                found: 2
            })
        ));
    }

    #[test]
    fn parse_multiple_validation_errors() {
        let map = DungeonMap::parse("###\n#T#").unwrap();
        let errors = map.validate().unwrap_err();
        assert!(map.validate().is_err());
        assert!(errors.contains(&ValidationError::MissingPlayerStart));
        assert!(errors.contains(&ValidationError::NoExit));
        assert!(errors.contains(&ValidationError::NoFloor));
    }

    #[test]
    fn parse_multiple_player_starts_returns_error() {
        let map = DungeonMap::parse("@.#.@\n.....\n.#@.#\n.X.T.").unwrap();
        let errors = map.validate().unwrap_err();
        let multiple_player_starts = errors
            .iter()
            .find(|e| matches!(e, ValidationError::MultiplePlayerStarts(_)));

        assert!(map.validate().is_err());
        match multiple_player_starts {
            Some(ValidationError::MultiplePlayerStarts(positions)) => {
                assert_eq!(positions.len(), 3);
                assert!(positions.contains(&(0, 0)));
                assert!(positions.contains(&(0, 4)));
                assert!(positions.contains(&(2, 2)));

                // checking the order (sorted positions)
                assert_eq!(positions[0], (0, 0));
                assert_eq!(positions[1], (0, 4));
                assert_eq!(positions[2], (2, 2));
            }

            _ => panic!("The MultiplePlayerStarts error expected, but not found."),
        }
    }
}
