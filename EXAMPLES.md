# Examples to configure a backup via restic

## Simple backup

```puppet
class { 'restic':
  backups => {
    'backup1' => {
      backup_path     => '/absolute/path',
      id              => 's3id',
      key             => 's3key',
      repository_host => 'host.name',
      repository_name => 'bucket_name/bucket_dir',
      repository_type => 's3',
      password        => 'somegoodpassword',
      forget          => {
        'keep-last' => 10,
      },
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
    repository_host: 'host.name'
    repository_name: 'bucket_name/bucket_dir'
    repository_type: 's3'
    password: 'somegoodpassword'
    forget:
      keep-last: 10
```

## Backup two directories into two different subs in the same bucket on the same host with pruning

```yaml
classes:
  - restic

restic::id: 's3id'
restic::key: 's3key'
restic::repository_host: 'host.name'
restic::repository_type: 's3'
restic::enable_forget: true
restic::forget:
  keep-last: 10
restic::prune: true
restic::backups:
  backup1:
    backup_path: '/absolute/path1'
    repository_name: 'bucket_name/backup1'
    password: 'somegoodpassword'
  backup2:
    backup_path: '/absolute/path2'
    repository_name: 'bucket_name/backup2'
    password: 'somegoodpassword'
```

## Disabling one of two backups

```yaml
classes:
  - restic

restic::id: 's3id'
restic::key: 's3key'
restic::repository_host: 'host.name'
restic::repository_type: 's3'
restic::backups:
  backup1:
    backup_path: '/absolute/path1'
    repository_name: 'bucket_name/backup1'
    password: 'somegoodpassword'
  backup2:
    path: '/absolute/path2'
    enable: false
```

## Only restore job

```yaml
classes:
  - restic

restic::id: 's3id'
restic::key: 's3key'
restic::repository_host: 'host.name'
restic::repository_type: 's3'
restic::backups:
  backup1:
    backup_path: '/absolute/path1'
    enable_backup: false
    restore_path: '/another/path1'
    enable_restore: true
    repository_name: 'bucket_name/backup1'
    password: 'somegoodpassword'
```
