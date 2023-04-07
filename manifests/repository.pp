# @summary
#   Configure a Restic service to backup/forget/restore data.
#
# @param backup_flags
#   Default flags for `restic backup <flags>`. See `restic backup --help`
#
# @param backup_path
#   Default directory to backed up
#
# @param backup_pre_cmd
#   Default command to run before `restic backup`
#
# @param backup_post_cmd
#   Default command to run after `restic backup`
#
# @param backup_timer
#   Default systemd timer for backup see: https://wiki.archlinux.de/title/Systemd/Timers
#
# @param backup_exit3_success
#   Consider restic's exit code 3 as success. https://restic.readthedocs.io/en/latest/040_backup.html#exit-status-codes
#
# @param binary
#   Default path to the Restic binary
#
# @param bucket
#   Default name for the Restic repository
#
# @param enable_backup
#   Default enable the backup service
#
# @param enable_forget
#   Default enable the forget service
#
# @param enable_restore
#   Default enable the restore service
#
# @param forget
#   Default hash with `keep-*` => `value` to configure forget flags
#
# @param forget_flags
#   Default flags for `restic forget <flags>`. See `restic forget --help`
#
# @param forget_pre_cmd
#   Default command to run before `restic forget`
#
# @param forget_post_cmd
#   Default command to run after `restic forget`
#
# @param forget_timer
#   Default systemd timer for forget see: https://wiki.archlinux.de/title/Systemd/Timers
#
# @param global_flags
#   Default global flags for `restic <flags>`. See `restic --help`
#
# @param group
#   Default group for systemd services
#
# @param host
#   Default hostname for the Restic repository
#
# @param id
#   Default S3 storage id for an S3 bucket, or username for sftp
#
# @param init_repo
#   Default enable the initialization of the repository
#
# @param key
#   Default S3 storage key for an S3 bucket
#
# @param password
#   Default encryption password for the Restic repository
#
# @param prune
#   Default enable `--prune` flag for `restic forget`
#
# @param restore_flags
#   Default flags for `restic restore <flags>`. See `restic restore --help`
#
# @param restore_path
#   Default directory used to restore a backup
#
# @param restore_pre_cmd command to run before execute restore
#   Default command to run before `restic restore`
#
# @param restore_post_cmd command to run after execute restore
#   Default command to run after `restic restore`
#
# @param restore_snapshot
#   Default Restic snapshot id used by the restore
#
# @param restore_timer
#   Default systemd timer for restore see: https://wiki.archlinux.de/title/Systemd/Timers
#
# @param type
#   Type for the Restic repository
#
# @param user
#   Default user for systemd services
#
define restic::repository (
  Optional[Variant[Array[String[1]],String[1]]] $backup_flags         = undef,
  Optional[Restic::Path]                        $backup_path          = undef,
  Optional[Variant[Array[String[1]],String[1]]] $backup_pre_cmd       = undef,
  Optional[Variant[Array[String[1]],String[1]]] $backup_post_cmd      = undef,
  Optional[String[1]]                           $backup_timer         = undef,
  Optional[Boolean]                             $backup_exit3_success = undef,
  Optional[Stdlib::Absolutepath]                $binary               = undef,
  Optional[String]                              $bucket               = undef,
  Optional[Boolean]                             $enable_backup        = undef,
  Optional[Boolean]                             $enable_forget        = undef,
  Optional[Boolean]                             $enable_restore       = undef,
  Optional[Restic::Forget]                      $forget               = undef,
  Optional[Variant[Array[String[1]],String[1]]] $forget_flags         = undef,
  Optional[Variant[Array[String[1]],String[1]]] $forget_pre_cmd       = undef,
  Optional[Variant[Array[String[1]],String[1]]] $forget_post_cmd      = undef,
  Optional[String[1]]                           $forget_timer         = undef,
  Optional[Variant[Array[String[1]],String[1]]] $global_flags         = undef,
  Optional[String]                              $group                = undef,
  Optional[String]                              $host                 = undef,
  Optional[String]                              $id                   = undef,
  Optional[Boolean]                             $init_repo            = undef,
  Optional[String]                              $key                  = undef,
  Optional[String]                              $password             = undef,
  Optional[Boolean]                             $prune                = undef,
  Optional[Variant[Array[String[1]],String[1]]] $restore_flags        = undef,
  Optional[Stdlib::Absolutepath]                $restore_path         = undef,
  Optional[Variant[Array[String[1]],String[1]]] $restore_pre_cmd      = undef,
  Optional[Variant[Array[String[1]],String[1]]] $restore_post_cmd     = undef,
  Optional[String[1]]                           $restore_snapshot     = undef,
  Optional[String[1]]                           $restore_timer        = undef,
  Optional[Restic::Repository::Type]            $type                 = undef,
  Optional[String[1]]                           $user                 = undef,
) {
  include restic

  $_backup_flags         = Array(pick($backup_flags, $restic::backup_flags))
  $_backup_path          = $backup_path.lest || { $restic::backup_path }
  $_backup_pre_cmd       = Array($backup_pre_cmd.lest || { $restic::backup_pre_cmd })
  $_backup_post_cmd      = Array($backup_post_cmd.lest || { $restic::backup_post_cmd })
  $_backup_exit3_success = pick($backup_exit3_success, $restic::backup_exit3_success)
  $_binary               = pick($binary, $restic::binary)
  $_bucket               = $bucket.lest || { $restic::bucket }
  $_enable_backup        = pick($enable_backup, $restic::enable_backup)
  $_enable_forget        = pick($enable_forget, $restic::enable_forget)
  $_enable_restore       = pick($enable_restore, $restic::enable_restore)
  $_forget               = pick($forget, $restic::forget)
  $_forget_flags         = Array(pick($forget_flags, $restic::forget_flags))
  $_forget_pre_cmd       = Array($forget_pre_cmd.lest || { $restic::forget_pre_cmd })
  $_forget_post_cmd      = Array($forget_post_cmd.lest || { $restic::forget_post_cmd })
  $_forget_timer         = $forget_timer.lest || { $restic::forget_timer }
  $_global_flags         = Array(pick($global_flags, $restic::global_flags))
  $_group                = pick($group, $restic::group)
  $_host                 = pick($host, $restic::host)
  $_id                   = $id.lest || { $restic::id }
  $_init_repo            = pick($init_repo, $restic::init_repo)
  $_key                  = $key.lest || { $restic::key }
  $_password             = pick($password, $restic::password)
  $_prune                = pick($prune, $restic::prune)
  $_restore_flags        = Array(pick($restore_flags, $restic::restore_flags))
  $_restore_path         = $restore_path.lest || { $restic::restore_path }
  $_restore_pre_cmd      = Array($restore_pre_cmd.lest || { $restic::restore_pre_cmd })
  $_restore_post_cmd     = Array($restore_post_cmd.lest || { $restic::restore_post_cmd })
  $_restore_snapshot     = pick($restore_snapshot, $restic::restore_snapshot)
  $_restore_timer        = $restore_timer.lest || { $restic::restore_timer }
  $_type                 = pick($type, $restic::type)

  if $_enable_backup and $_backup_path == undef {
    fail("restic::repository[${title}]: You have to set \$backup_path if you enable the backup!")
  }

  if $_enable_restore and $_restore_path == undef {
    fail("restic::repository[${title}]: You have to set \$restore_path if you enable the restore!")
  }

  if $_type == 'sftp' {
    $_sftp_username = $_id
    $_sftp_path = pick($_bucket, 'restic-repo')

    $repository = "${_type}:${_sftp_username}@${_host}:${_sftp_path}"
  } else {
    $repository = $_bucket ? {
      undef   => "${_type}:${_host}",
      default => "${_type}:${_host}/${_bucket}",
    }
  }

  $config_file   = "${restic::config_directory}/${title}.env"
  $type_config   = $_type ? {
    's3'    => {
      'AWS_ACCESS_KEY_ID'     => $_id,
      'AWS_SECRET_ACCESS_KEY' => $_key,
      'RESTIC_PASSWORD'       => $_password,
      'RESTIC_REPOSITORY'     => $repository,
    },
    default => {
      'RESTIC_PASSWORD'   => $_password,
      'RESTIC_REPOSITORY' => $repository,
    },
  }

  if $_init_repo {
    exec { "restic_init_${repository}_${title}":
      command     => "${_binary} init",
      environment => $type_config.map |$key, $value| { "${key}=${value}" },
      onlyif      => "${_binary} snapshots 2>&1 | grep -q 'Is there a repository at the following location'",
      require     => Class['restic::package'],
    }
  }

  if $_enable_backup or $_enable_forget or $_enable_restore {
    include restic::config

    concat { $config_file:
      ensure         => 'present',
      ensure_newline => true,
      group          => $_group,
      mode           => '0440',
      owner          => 'root',
      show_diff      => true,
    }

    $config_keys = {
      'GLOBAL_FLAGS' => $_global_flags.join(' '),
    } + $type_config

    concat::fragment { "restic_fragment_${title}":
      content => epp("${module_name}/config.env.epp", { 'config' => $config_keys }),
      target  => $config_file,
    }
  } else {
    concat { $config_file:
      ensure => 'absent',
    }
  }

  ##
  ## backup service
  ##
  $backup_config_file = "${restic::config_directory}/${title}-backup.env"
  $backup_commands = $_backup_pre_cmd + ["${_binary} backup \$GLOBAL_FLAGS \$BACKUP_FLAGS"] + $_backup_post_cmd

  restic::service::instance { "backup-${title}":
    ensure        => bool2str($_enable_backup, 'present', 'absent'),
    user          => $user,
    group         => $_group,
    timer         => $backup_timer,
    commands      => $backup_commands,
    config        => {
      'BACKUP_FLAGS' => join($_backup_flags + [$_backup_path], ' '),
    },
    service_entry => {
      'SuccessExitStatus' => if $_backup_exit3_success { 3 } else { undef },
    },
  }

  ##
  ## forget service
  ##
  $forget_commands = $_forget_pre_cmd + ["${_binary} forget \$GLOBAL_FLAGS \$FORGET_FLAGS"] + $_forget_post_cmd
  $forgets = $_forget.map |$k,$v| { "--${k} ${v}" }
  $forget_prune  = if $_prune { ['--prune'] } else { [] }

  restic::service::instance { "forget-${title}":
    ensure   => bool2str($_enable_forget, 'present', 'absent'),
    user     => $user,
    group    => $_group,
    timer    => $_forget_timer,
    commands => $forget_commands,
    config   => {
      'FORGET_FLAGS' => join($forgets + $forget_prune + $_forget_flags, ' '),
    },
  }

  ##
  ## restore service
  ##
  $restore_commands = $_restore_pre_cmd + ["${_binary} restore \$GLOBAL_FLAGS \$RESTORE_FLAGS"] + $_restore_post_cmd

  restic::service::instance { "restore-${title}":
    ensure   => bool2str($_enable_restore, 'present', 'absent'),
    user     => $user,
    group    => $_group,
    timer    => $_restore_timer,
    commands => $restore_commands,
    config   => {
      'RESTORE_FLAGS' => join(["-t ${_restore_path}"] + $_restore_flags + [$_restore_snapshot], ' '),
    },
  }
}
