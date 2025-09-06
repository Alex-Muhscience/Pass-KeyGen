# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- Fixed deprecated `withOpacity()` calls replaced with `withValues(alpha: ...)` across multiple files
- Fixed private state classes made public to resolve "private type in public API" warnings
- Fixed BuildContext usage across async gaps by adding proper `mounted` checks
- Fixed syntax errors in `security_dashboard_page.dart` related to widget parameters
- Fixed deprecated URL launcher methods (`canLaunch`/`launch` → `canLaunchUrl`/`launchUrl`)
- Fixed constant naming conventions to use lowerCamelCase instead of UPPER_CASE
- Fixed `LinearProgressIndicator` usage by wrapping with `ClipRRect` and `SizedBox` for proper styling

### Changed
- Updated Android Gradle Plugin from 7.3.0 to 8.6.0
- Updated Kotlin version from 1.7.10 to 1.8.10
- Updated Gradle version from 8.3 to 8.7
- Updated file_picker dependency from 6.1.1 to 6.2.1
- Updated documentation with new build requirements
- Improved code compliance with Flutter best practices

### Technical Details
- **Files Modified**: 15+ Dart files across pages, services, widgets, and utilities
- **Deprecation Fixes**: Replaced all deprecated API calls with modern equivalents
- **Build System**: Updated Android build configuration for compatibility
- **Code Quality**: Enhanced error handling and async safety patterns

## [1.0.0] - Initial Release

### Added
- Complete password manager functionality
- Military-grade AES-256-GCM encryption
- Biometric authentication support
- Family sharing capabilities
- Cross-platform support (Android, iOS, Web, Windows, macOS, Linux)
- Multi-language support (12 languages)
- Security audit dashboard
- Password generator with customizable rules
- Import/export functionality
- Two-factor authentication support
