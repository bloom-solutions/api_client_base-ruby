# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [1.4.0] - 2018-08-29
### Added
- Support `host` configurations that already have a path

## [1.3.0] - 2018-08-29
### Added
- Make defining of `path` in requests optional

## [1.2.0] - 2017-02-22
### Added
- raise ArgumentError when validation schema is available and it has errors

## [1.1.0] - 2017-02-17
### Added
- `Client` inherits attributes from gem namespace. No need to specify these attributes again.

## [1.0.0] - 2017-02-15
### Fixed
- Ensure args are passed correctly into request instantiation

## [0.2.1] - 2017-02-13
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
