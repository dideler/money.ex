# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2025-12-11

### Added
- CHANGELOG file
- Expose version via `Money.version/0`
- Add and run doctests for `sigil_M/2` and `allocate/2`
- Add support for underscores when using sigil shorthand
- `Money.Util.normalize_ratios/1` as a test helper for testing `Money.allocate/2`
  with fractional allocation parts (instead of integer) to recreate a specific
  complex test case. It's not yet part of the public API - still deciding.

### Fixed
- Fix ordering of results for `Money.allocate/2`
- Fix handling of negative amounts for `Money.allocate/2`

### Changed
- README minor edits

## [0.2.0] - 2025-11-13

### Added
- Add `Money.allocate/2` for splitting money into weighted shares
- Add specs and types for string functions

### Changed
- Refactor digit formatting for `to_string/2`
- Use `ArgumentError` for bad input to `split/2` instead of `ArithmeticError`
- Minor README updates
- Bumped ExDoc to v0.39

## [0.1.2] - 2025-09-15

Initial working public release (v0.1.0 and v0.1.1 had issues).


[Unreleased]: https://github.com/dideler/money.ex/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/dideler/money.ex/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/dideler/money.ex/releases/tag/v0.2.0
[0.1.2]: https://github.com/dideler/money.ex/releases/tag/v0.1.2
