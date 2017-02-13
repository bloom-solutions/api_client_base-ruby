# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [TBA]
### Fixed
- bug with customizing the args of an `api_action` (it didn't work at all!)
- when building path, escape the values

## [0.2.0]
### Added
- Convenience module for gem's base module

### Fixed
- Do not require arguments to be passed into api actions
- Do not singularize the action_name. Call camelize instead of classify

### Changed
- Typhoeus is not a dependency; user must add it if they will use `Request#call`

## [0.1.0] - 2016-12-15
### Added
- Initial release
