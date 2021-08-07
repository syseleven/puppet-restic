# Changelog

All notable changes to this project will be documented in this file.

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
