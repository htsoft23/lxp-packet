# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0] - 2020-04-07

### Added

- parsing of ReadHold packets with multiple registers/values
- beginnings of a test suite!


## [0.3.0] - 2020-04-02

### Fixed

- decoding energy accumulation figures in ReadInput1 packets


## [0.2.0] - 2020-01-26

### Fixed

- bitshifting logic when reading packets


## [0.1.2] - 2020-01-15

### Changed

- move Utils module into LXP namespace
- add Packet#tcp_function
- add Heartbeat packet support


## [0.1.0] - 2020-01-05

### Added

- Initial release
