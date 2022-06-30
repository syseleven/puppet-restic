# Examples to configure a backup via restic

## Simple backup

```puppet
class { 'restic':
  backups => {
    'backup1' => {
      backup_path => '/absolute/path',
      bucket      => 'bucket_name/bucket_dir',
      forget      => {
        'keep-last' => 10,
      },
      host        => 'host.name',
      id          => 's3id',
      key         => 's3key',
      password    => 'somegoodpassword',
      type        => 's3',
    },
  },
}
```

```yaml
classes:
  - restic

restic::backups:
  backup1:
    backup_path: '/absolute/path'
    id: 's3id'
    key: 's3key'
    host: 'host.name'
    bucket: 'bucket_name/bucket_dir'
    type: 's3'
    password: 'somegoodpassword'
    forget:
      keep-last: 10
```

## Backup two directories into two different subs in the same bucket on the same host with pruning

```yaml
classes:
  - restic

restic::enable_backup: true
restic::enable_forget: true
restic::backup_timer: 'Mon..Sun *:00:00'
restic::forget_timer: Mon..Sun 23:00:00
restic::host: 'host.name'
restic::id: 's3id'
restic::key: 's3key'
restic::type: 's3'
restic::forget:
  keep-last: 10
restic::prune: true
restic::backups:
  backup1:
    backup_path: '/absolute/path1'
    bucket: 'bucket_name/backup1'
    password: 'somegoodpassword'
  backup2:
    backup_path: '/absolute/path2'
    bucket: 'bucket_name/backup2'
    password: 'somegoodpassword'
```

## Disabling one of two backups

```yaml
classes:
  - restic

restic::id: 's3id'
restic::key: 's3key'
restic::host: 'host.name'
restic::type: 's3'
restic::backups:
  backup1:
    backup_path: '/absolute/path1'
    bucket: 'bucket_name/backup1'
    enable_backup: true
    password: 'somegoodpassword'
  backup2:
    enable_backup: false
    path: '/absolute/path2'
```

## Only restore job

```yaml
classes:
  - restic

restic::id: 's3id'
restic::key: 's3key'
restic::host: 'host.name'
restic::type: 's3'
restic::backups:
  restore1:
    restore_path: '/another/path1'
    enable_restore: true
    bucket: 'bucket_name/restore1'
    password: 'somegoodpassword'
```

You can execute the job manually via:
```shell
systemctl start restic_restore_restore1.service
```
