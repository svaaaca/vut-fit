# Project Notes — Dungeon Map Scribe

### Implementation Highlights
* **Parsing**: Uses a functional approach with `collect::<Result<Vec<Vec<Tile>>, ParseError>>()` to cleanly propagate errors during row and character transformation.
* **Validation**: Implemented without the `?` operator to ensure all `ValidationError` variants are accumulated into a single vector before returning.
* **Reachability**: Employs a BFS algorithm using `VecDeque` for the frontier and a `HashSet` to track visited positions.
* **Report Generation**: Labels are padded to 13 characters. This follows the clarified specification where the longest label (`"PlayerStart:"`) takes 12 chars plus 1 mandatory space separator.

### Assumptions & Input Handling
* **Whitespace**: Leading, trailing, and internal blank lines are filtered out. However, spaces within a map row are treated as `UnknownTile` errors to ensure position accuracy.
* **Line Endings**: Explicitly strips `\r` characters before parsing to ensure full compatibility with both Unix and Windows text files.
* **Edge Cases**: If multiple `PlayerStart` tiles exist, the reachability score in the report defaults to `0` to avoid ambiguity in an invalid map state.

### Constraints & Safety
* **Zero Dependencies**: The project strictly uses the Rust Standard Library (`std`) with no external crates.
* **Error Handling**: Follows safe Rust practices; the codebase contains no instances of `unwrap()` or `expect()`.
