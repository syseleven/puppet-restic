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
#   Default S3 storage id for an S3 bucket
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
#   Default name for the Restic repository. Only S3 supported
#
# @param user
#   Default user for systemd services
#
define restic::repository (
  Optional[Boolean]                             $backup_exit3_success = undef,
  Optional[Variant[Array[String[1]],String[1]]] $backup_flags         = undef,
  Optional[Restic::Path]                        $backup_path          = undef,
  Optional[Variant[Array[String[1]],String[1]]] $backup_post_cmd      = undef,
  Optional[Variant[Array[String[1]],String[1]]] $backup_pre_cmd       = undef,
  Optional[String[1]]                           $backup_timer         = undef,
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
  Optional[Variant[Sensitive[String],String]]   $host                 = undef,
  Optional[Variant[Sensitive[String],String]]   $id                   = undef,
  Optional[Boolean]                             $init_repo            = undef,
  Optional[Variant[Sensitive[String],String]]   $key                  = undef,
  Optional[Variant[Sensitive[String],String]]   $password             = undef,
  Optional[Boolean]                             $prune                = undef,
  Optional[Variant[Array[String[1]],String[1]]] $restore_flags        = undef,
  Optional[Stdlib::Absolutepath]                $restore_path         = undef,
  Optional[Variant[Array[String[1]],String[1]]] $restore_post_cmd     = undef,
  Optional[Variant[Array[String[1]],String[1]]] $restore_pre_cmd      = undef,
  Optional[String[1]]                           $restore_snapshot     = undef,
  Optional[String[1]]                           $restore_timer        = undef,
  Optional[Restic::Repository::Type]            $type                 = undef,
  Optional[String[1]]                           $user                 = undef,
) {
  include restic

  $_backup_exit3_success = pick($backup_exit3_success, $restic::backup_exit3_success)
  $_backup_flags         = pick($backup_flags, $restic::backup_flags)
  $_backup_path          = $backup_path.lest || { $restic::backup_path }
  $_backup_post_cmd      = $backup_post_cmd.lest || { $restic::backup_post_cmd }
  $_backup_pre_cmd       = $backup_pre_cmd.lest || { $restic::backup_pre_cmd }
  $_backup_timer         = $backup_timer.lest || { $restic::backup_timer }
  $_binary               = pick($binary, $restic::binary)
  $_bucket               = $bucket.lest || { $restic::bucket }
  $_enable_backup        = pick($enable_backup, $restic::enable_backup)
  $_enable_forget        = pick($enable_forget, $restic::enable_forget)
  $_enable_restore       = pick($enable_restore, $restic::enable_restore)
  $_forget               = pick($forget, $restic::forget)
  $_forget_flags         = pick($forget_flags, $restic::forget_flags)
  $_forget_post_cmd      = $forget_post_cmd.lest || { $restic::forget_post_cmd }
  $_forget_pre_cmd       = $forget_pre_cmd.lest || { $restic::forget_pre_cmd }
  $_forget_timer         = $forget_timer.lest || { $restic::forget_timer }
  $_global_flags         = pick($global_flags, $restic::global_flags)
  $_group                = pick($group, $restic::group)
  $_host                 = pick($host, $restic::host)
  $_id                   = $id.lest || { $restic::id }
  $_init_repo            = pick($init_repo, $restic::init_repo)
  $_key                  = $key.lest || { $restic::key }
  $_password             = pick($password, $restic::password)
  $_prune                = pick($prune, $restic::prune)
  $_restore_flags        = pick($restore_flags, $restic::restore_flags)
  $_restore_path         = $restore_path.lest || { $restic::restore_path }
  $_restore_post_cmd     = $restore_post_cmd.lest || { $restic::restore_post_cmd }
  $_restore_pre_cmd      = $restore_pre_cmd.lest || { $restic::restore_pre_cmd }
  $_restore_snapshot     = pick($restore_snapshot, $restic::restore_snapshot)
  $_restore_timer        = $restore_timer.lest || { $restic::restore_timer }
  $_type                 = pick($type, $restic::type)
  $_user                 = pick($user, $restic::user)

  if $_enable_backup and $_backup_path == undef {
    fail("restic::repository[${title}]: You have to set \$backup_path if you enable the backup!")
  }

  if $_enable_restore and $_restore_path == undef {
    fail("restic::repository[${title}]: You have to set \$restore_path if you enable the restore!")
  }

  $success_exit_status = $_backup_exit3_success ? {
    true    => 3,
    default => undef,
  }

  $repository    = $_bucket ? {
    undef   => "${_type}:${_host.unwrap}",
    default => "${_type}:${_host.unwrap}/${_bucket}",
  }

  $config_file   = "/etc/default/restic_${title}"
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
    exec { "restic_init_${title}":
      command     => "${_binary} init",
      # TODO: Make environment a Sensitive data type as well. But this is currently not supported by Puppet
      # https://github.com/puppetlabs/puppet/blob/f4781e349d0089061d05f1e8e6e3c3d44a7e1e04/lib/puppet/type/exec.rb#L692
      environment => $type_config.reduce([]) |$memo,$item| { $memo + "${item[0]}=${item[1].unwrap}" }.sort,
      onlyif      => "${_binary} snapshots 2>&1 | grep -q 'Is there a repository at the following location'",
    }
  }

  if $_enable_backup or $_enable_forget or $_enable_restore {
    concat { $config_file:
      ensure         => 'present',
      ensure_newline => true,
      group          => 'root',
      mode           => '0440',
      owner          => 'root',
      show_diff      => true,
    }

    $config_keys = {
      'GLOBAL_FLAGS' => [ $_global_flags, ].flatten.join(' '),
    } + $type_config

    $config_keys.each |$config,$data| {
      concat::fragment { "restic_fragment_${title}_${config}":
        content => Sensitive("${config}='${data.unwrap}'"), # unwarp, becase concating Sensitive strings doesn't work.
        target  => $config_file,
      }
    }
  } else {
    concat { $config_file:
      ensure => 'absent',
    }
  }

  ##
  ## backup service
  ##
  $backup_commands = [
    $_backup_pre_cmd,
    "${_binary} backup \$GLOBAL_FLAGS \$BACKUP_FLAGS",
    $_backup_post_cmd,
  ].flatten.delete_undef_values

  $backup_keys = {
    'BACKUP_FLAGS' => [ $_backup_flags, $_backup_path, ].flatten.join(' '),
  }

  restic::service { "restic_backup_${title}":
    commands            => $backup_commands.delete_undef_values,
    config              => $config_file,
    configs             => $backup_keys,
    enable              => $_enable_backup,
    group               => $_group,
    timer               => $_backup_timer,
    success_exit_status => $success_exit_status,
    user                => $_user,
  }

  ##
  ## forget service
  ##
  $forget_commands = [
    $_forget_pre_cmd,
    "${_binary} forget \$GLOBAL_FLAGS \$FORGET_FLAGS",
    $_forget_post_cmd,
  ].flatten.delete_undef_values

  $forgets       = $_forget.map |$k,$v| { "--${k} ${v}" }
  $forget_prune  = if $_prune { '--prune' } else { undef }
  $forget_keys   = {
    'FORGET_FLAGS' => [ $forgets, $forget_prune, $_forget_flags, ].delete_undef_values.flatten.join(' '),
  }

  restic::service { "restic_forget_${title}":
    commands => $forget_commands.delete_undef_values,
    config   => $config_file,
    configs  => $forget_keys,
    enable   => $_enable_forget,
    group    => $_group,
    timer    => $_forget_timer,
    user     => $_user,
  }

  ##
  ## restore service
  ##
  $restore_commands = [
    $_restore_pre_cmd,
    "${_binary} restore \$GLOBAL_FLAGS \$RESTORE_FLAGS",
    $_restore_post_cmd,
  ].flatten.delete_undef_values

  $restore_keys = {
    'RESTORE_FLAGS' => [ "-t ${_restore_path}", $_restore_flags, $_restore_snapshot, ].flatten.join(' '),
  }

  restic::service { "restic_restore_${title}":
    commands => $restore_commands.delete_undef_values,
    config   => $config_file,
    configs  => $restore_keys,
    enable   => $_enable_restore,
    group    => $_group,
    timer    => $_restore_timer,
    user     => $_user,
  }
}
