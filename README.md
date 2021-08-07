## Overview

This module manages Restic repositories via Puppet with systemd service and timer units. See: https://restic.net/

**!!! This module has only been tested on Ubuntu 20.04 !!!**

## Features

* Backup
* Forget
* Restore

## Module Description

By default **$enable_backup**, **$enable_forget**, and **$enable_restore** are **false**.

For each repository you enable a systemd service will be installed. To trigger the service automatically you have to set a [systemd timer value](https://wiki.archlinux.de/title/Systemd/Timers) (**$backup_timer**, **$forget_timer**, **$restore_timer**).

By default **no** timer is set.

If you don't enable any feature the Restic repository will only be initialized.

## Usage

### Initialize Restic repository only on an S3 Bucket

```yaml
---
classes:
  - restic

restic::repositories:
  some_repo1:
    enable_backup: false
    id: a3f5173hdsks934
    key: y7ahajhsd3uzasa
    password: yxcvasdf1234
    host: some.host.name
    bucket: bucket_name/backup1
```

### Add a simple backup

Configure a repository and backup 2 directories

```yaml
---
classes:
  - restic

restic::repositories:
  some_repo2:
    backup_path:
      - /full/path/1
      - /some/other/path
    backup_timer: Mon..Sun 20:00:00
    bucket: bucket_name/backup1
    enable_backup: true
    host: some.host.name
    id: a3f5173hdsks934
    key: y7ahajhsd3uzasa
    password: yxcvasdf1234
```

Add cleanup via the forget service

```yaml
restic::repositories:
  some_repo2:
    ...
    enable_forget: true
    forget_timer: Mon..Sun 23:00:00
```

### Add two backups on the same S3 Bucket

```yaml
---
classes:
  - restic

restic::id: a3f5173hdsks934
restic::key: y7ahajhsd3uzasa
restic::host: some.host.name
restic::repositories:
  some_repo3:
    backup_path:
      - /full/path/1
      - /some/other/path
    bucket: bucket_name/backup1
    password: yxcvasdf1234
  some_repo4:
    backup_path: /other/path
    bucket: bucket_name/backup2
    password: yxcvasd3456f1234
```

### Add two backups on the different S3 Buckets with different access data on the same host

```yaml
---
classes:
  - restic

restic::host: some.host.name
restic::repositories:
  some_repo1:
    backup_path:
      - /full/path/1
      - /some/other/path
    bucket: bucket_name1/backup1
    id: a3f5173hdsks934
    key: y7ahajhsd3uzasa
    password: yxcvasdf1234
  some_repo2:
    backup_path: /other/path
    bucket: bucket_name2/backup2
    id: y7ahajhsd3uzasa
    key: a3f5173hdsks934
    password: yxcvasd3456f1234
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
restic::host: some.host.name
restic::repositories:
  some_repo3:
    restore_path: /full/path/restore
    bucket: bucket_name/backup1
    password: yxcvasdf1234
  some_repo4:
    backup_path: /other/path
    bucket: bucket_name/backup2
    password: yxcvasd3456f1234
```

### Other exmaples

Can be found in [EXAMPLES](EXAMPLES.md).

## Development

If you'd like to contribute, please see [CONTRIBUTING](CONTRIBUTING.md).
