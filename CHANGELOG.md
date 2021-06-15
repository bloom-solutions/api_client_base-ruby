# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
- `dry-validation` 1.x support (0.x support has not been dropped)

## [1.9.0] - 2020-06-30
### Added
- Allow users to override typhoeus_options to pass any args that we haven't defined

## [1.8.0] - 2020-06-30
### Added
- Allow all Typhoeus options to be passed to BuildTyphoeusOptions. This is useful when overriding the method `typhoeus_options` in requests

## [1.7.0] - 2020-04-15
### Added
- Add `Response#body` which is `raw_response`'s `body`

## [1.6.0] - 2020-04-09
### Added
- Move http-related code to Request#run. This is the one that should be overridden, instead of call, since `#call` calls other methods like `before_call`
- Set `#proxy` attribute to requests. This is passed to Typhoeus if present

## [1.5.0] - 2019-04-03
### Added
- Allow developer to define `before_call` in requests to execute code

## [1.4.1] - 2019-01-30
### Fixed
- `host` configuration should not remove the path

## [1.4.0] - 2018-09-04
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
