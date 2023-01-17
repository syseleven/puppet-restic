# Changelog

All notable changes to this project will be documented in this file.

## Release 2.5.0

**Features**
- Add pre/post command defined for service from Matthias Baur <m.baur@syseleven.de>

## Release 2.4.0

**Features**
- Allow the installation of restic through url download from Matthias Baur <m.baur@syseleven.de>

## Release 2.3.0

**Features**
- Bucket can be empty for non s3 repositories from Matthias Baur <m.baur@syseleven.de>
- Allow *_cmd parameters to be an Array from Matthias Baur <m.baur@syseleven.de>

## Release 2.2.4

**Features**
- Allow inclusion of restic::repository from Matthias Baur <m.baur@syseleven.de>
- Support 'rest' repository type from Matthias Baur <m.baur@syseleven.de>

## Release 2.2.3

**Features**
- revert Sensitive id, key, and password

## Release 2.2.2

**Features**
- make id, key, and password Sensitive

## Release 2.2.1

- broken release

## Release 2.2.0

**Features**
- add 22.04 support

## Release 2.1.0

**Bugfixes**
- default for enable_backup set to true to reflect docs (Issue #9)

## Release 2.0.3

**Bugfixes**
- fix file unsecure file permissions (Issue #6)

## Release 2.0.2

**Bugfixes**
- user and group assignment for the backup service resource (Issue #3)
- deduplicate resource for initialize restic repository (Issue #4)
- user and group assignment for the restore/forget service resource (no issue)

## Release 2.0.1

**Bugfixes**
- run failed if backup, restore and forget have been disabled (Issue #1)

## Release 2.0.0

**Features**

### Renamed paramter
- **$repository_type** >> **$type**
- **$repository_name** >> **$bucket**
- **$repository_host** >> **$host**
- **$timer** >> **$backup_timer**

### Added parameter
- **$restore_timer**

### Changed default values
- **$enable_backup** is now **false**
- **restore_path** is now **undef**
- **type** is now **s3**

### Added more complex rspec tests

**Bugfixes**
- fixed timer rollout

**Known Issues**
- none

## Release 1.0.0

**Features**
- initialize a Restic repository at S3
- backup/restore/forget data at an S3 Restic repository

**Bugfixes**
- none

**Known Issues**
- none
