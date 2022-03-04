# @summary
#   Configure a Restic service to backup/forget/restore data.
#
# @api private
#
define restic::repository (
  Variant[Array[String[1]],String[1]] $backup_flags     = $restic::backup_flags,
  Optional[Restic::Path]              $backup_path      = $restic::backup_path,
  Optional[String[1]]                 $backup_pre_cmd   = $restic::backup_pre_cmd,
  Optional[String[1]]                 $backup_post_cmd  = $restic::backup_post_cmd,
  Optional[String[1]]                 $backup_timer     = $restic::backup_timer,
  Stdlib::Absolutepath                $binary           = $restic::binary,
  Optional[String]                    $bucket           = $restic::bucket,
  Boolean                             $enable_backup    = $restic::enable_backup,
  Boolean                             $enable_forget    = $restic::enable_forget,
  Boolean                             $enable_restore   = $restic::enable_restore,
  Restic::Forget                      $forget           = $restic::forget,
  Variant[Array[String[1]],String[1]] $forget_flags     = $restic::forget_flags,
  Optional[String[1]]                 $forget_pre_cmd   = $restic::forget_pre_cmd,
  Optional[String[1]]                 $forget_post_cmd  = $restic::forget_post_cmd,
  Optional[String[1]]                 $forget_timer     = $restic::forget_timer,
  Variant[Array[String[1]],String[1]] $global_flags     = $restic::global_flags,
  String                              $group            = $restic::group,
  Optional[String]                    $host             = $restic::host,
  Optional[String]                    $id               = $restic::id,
  Boolean                             $init_repo        = $restic::init_repo,
  Optional[String]                    $key              = $restic::key,
  Optional[String]                    $password         = $restic::password,
  Boolean                             $prune            = $restic::prune,
  Variant[Array[String[1]],String[1]] $restore_flags    = $restic::restore_flags,
  Optional[Stdlib::Absolutepath]      $restore_path     = $restic::restore_path,
  Optional[String[1]]                 $restore_pre_cmd  = $restic::restore_pre_cmd,
  Optional[String[1]]                 $restore_post_cmd = $restic::restore_post_cmd,
  String[1]                           $restore_snapshot = $restic::restore_snapshot,
  Optional[String[1]]                 $restore_timer    = $restic::restore_timer,
  Restic::Repository::Type            $type             = $restic::type,
  String[1]                           $user             = $restic::user,
) {
  assert_private()

  if $enable_backup and $backup_path == undef {
    fail("restic::repository[${title}]: You have to set \$backup_path if you enable the backup!")
  }

  if $enable_restore and $restore_path == undef {
    fail("restic::repository[${title}]: You have to set \$restore_path if you enable the restore!")
  }

  $repository  = "${type}:${host}/${bucket}"
  $config_file = "/etc/default/restic_${title}"

  if $init_repo {
    exec { "restic_init_${repository}_${title}":
      command     => "${binary} init",
      environment => [
        "AWS_ACCESS_KEY_ID=${id}",
        "AWS_SECRET_ACCESS_KEY=${key}",
        "RESTIC_PASSWORD=${password}",
        "RESTIC_REPOSITORY=${repository}",
      ],
      onlyif      => "${binary} snapshots 2>&1 | grep -q 'Is there a repository at the following location'",
    }
  }

  if $enable_backup or $enable_forget or $enable_restore {
    concat { $config_file:
      ensure         => 'present',
      ensure_newline => true,
      group          => 'root',
      mode           => '0440',
      owner          => 'root',
      show_diff      => true,
    }

    $config_keys = {
      'AWS_ACCESS_KEY_ID'     => $id,
      'AWS_SECRET_ACCESS_KEY' => $key,
      'GLOBAL_FLAGS'          => [ $global_flags, ].flatten.join(' '),
      'RESTIC_PASSWORD'       => $password,
      'RESTIC_REPOSITORY'     => $repository,
    }

    $config_keys.each |$config,$data| {
      concat::fragment { "restic_fragment_${title}_${config}":
        content => "${config}='${data}'",
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
    $backup_pre_cmd,
    "${binary} backup \$GLOBAL_FLAGS \$BACKUP_FLAGS",
    $backup_post_cmd,
  ].delete_undef_values

  $backup_keys = {
    'BACKUP_FLAGS' => [ $backup_flags, $backup_path, ].flatten.join(' '),
  }

  restic::service { "restic_backup_${title}":
    commands => $backup_commands.delete_undef_values,
    config   => $config_file,
    configs  => $backup_keys,
    enable   => $enable_backup,
    group    => $group,
    timer    => $backup_timer,
    user     => $user,
  }

  ##
  ## forget service
  ##
  $forget_commands = [
    $forget_pre_cmd,
    "${binary} forget \$GLOBAL_FLAGS \$FORGET_FLAGS",
    $forget_post_cmd,
  ]

  $forgets       = $forget.map |$k,$v| { "--${k} ${v}" }
  $forget_prune  = if $prune { '--prune' } else { undef }
  $forget_keys   = {
    'FORGET_FLAGS' => [ $forgets, $forget_prune, $forget_flags, ].delete_undef_values.flatten.join(' '),
  }

  restic::service { "restic_forget_${title}":
    commands => $forget_commands.delete_undef_values,
    config   => $config_file,
    configs  => $forget_keys,
    enable   => $enable_forget,
    group    => $group,
    timer    => $forget_timer,
    user     => $user,
  }

  ##
  ## restore service
  ##
  $restore_commands = [
    $restore_pre_cmd,
    "${binary} restore \$GLOBAL_FLAGS \$RESTORE_FLAGS",
    $restore_post_cmd,
  ]

  $restore_keys = {
    'RESTORE_FLAGS' => [ "-t ${restore_path}", $restore_flags, $restore_snapshot, ].flatten.join(' '),
  }

  restic::service { "restic_restore_${title}":
    commands => $restore_commands.delete_undef_values,
    config   => $config_file,
    configs  => $restore_keys,
    enable   => $enable_restore,
    group    => $group,
    timer    => $restore_timer,
    user     => $user,
  }
}
