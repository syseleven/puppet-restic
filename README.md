
## Overview

This module manages Restic repositories via Puppet. See: https://restic.net/

## Module Description

This module provides a Puppet class that can be used to manage Restic repositories.

## Usage

### Initialize Restic repository only on an S3 Bucket

```yaml
---
classes:
  - restic

restic::repositories:
  'some_repo':
    enable_backup: false
    id: a3f5173hdsks934
    key: y7ahajhsd3uzasa
    password: yxcvasdf1234
    repository_host: some.host.name
    repository_name: bucket_name/backup1
```

### Add a simple backup

Configure a repository and backup 2 directories

```yaml
---
classes:
  - restic

restic::repositories:
  'some_repo':
    backup_path:
      - /full/path/1
      - /some/other/path
    id: a3f5173hdsks934
    key: y7ahajhsd3uzasa
    password: yxcvasdf1234
    repository_host: some.host.name
    repository_name: bucket_name/backup1
```

Add cleanup via the forget service

```yaml
restic::repositories:
  'some_repo':
    ...
    enable_forget: true
    forget_timer: 'Mon..Sun 23:00:00'
```

### Add two backups on the same S3 Bucket

```yaml
---
classes:
  - restic

restic::id: a3f5173hdsks934
restic::key: y7ahajhsd3uzasa
restic::repository_host: some.host.name
restic::repositories:
  'some_repo':
    backup_path:
      - /full/path/1
      - /some/other/path
    password: yxcvasdf1234
    repository_name: bucket_name/backup1
  'some_repo':
    backup_path: /other/path
    password: yxcvasd3456f1234
    repository_name: bucket_name/backup2
```

### Add two backups on the different S3 Buckets with different access data on the same host

```yaml
---
classes:
  - restic

restic::repository_host: some.host.name
restic::repositories:
  'some_repo':
    id: a3f5173hdsks934
    key: y7ahajhsd3uzasa
    backup_path:
      - /full/path/1
      - /some/other/path
    password: yxcvasdf1234
    repository_name: bucket_name1/backup1
  'some_repo':
    id: y7ahajhsd3uzasa
    key: a3f5173hdsks934
    backup_path: /other/path
    password: yxcvasd3456f1234
    repository_name: bucket_name2/backup2
```

### Add two restore only job from the same S3 Repository

```yaml
---
classes:
  - restic

restic::enable_backup: false
restic::enable_restore: true
restic::id: a3f5173hdsks934
restic::key: y7ahajhsd3uzasa
restic::repository_host: some.host.name
restic::repositories:
  'some_repo':
    restore_path: /full/path/restore
    repository_name: bucket_name/backup1
    password: yxcvasdf1234
  'some_repo':
    backup_path: /other/path
    repository_name: bucket_name/backup2
    password: yxcvasd3456f1234
```

### Other exmaples

Can be found in [EXAMPLES](EXAMPLES.md).

## Development

If you'd like to contribute, please see [CONTRIBUTING](CONTRIBUTING.md).
