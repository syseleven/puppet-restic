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
  Stdlib::Absolutepath                $binary           = $restic::binary,
  Boolean                             $enable_backup    = $restic::enable_backup,
  Boolean                             $enable_forget    = $restic::enable_forget,
  Boolean                             $enable_restore   = $restic::enable_restore,
  Optional[Restic::Forget]            $forget           = $restic::forget,
  Variant[Array[String[1]],String[1]] $forget_flags     = $restic::forget_flags,
  Optional[String[1]]                 $forget_pre_cmd   = $restic::forget_pre_cmd,
  Optional[String[1]]                 $forget_post_cmd  = $restic::forget_post_cmd,
  String[1]                           $forget_timer     = $restic::timer,
  Variant[Array[String[1]],String[1]] $global_flags     = $restic::global_flags,
  String[1]                           $group            = $restic::group,
  String[1]                           $id               = $restic::id,
  Boolean                             $init_repo        = $restic::init_repo,
  String[1]                           $key              = $restic::key,
  Optional[String[1]]                 $password         = $restic::password,
  Boolean                             $prune            = $restic::prune,
  Optional[String[1]]                 $repository_host  = $restic::repository_host,
  Optional[String[1]]                 $repository_name  = $restic::repository_name,
  Restic::Repository::Type            $repository_type  = $restic::repository_type,
  Variant[Array[String[1]],String[1]] $restore_flags    = $restic::restore_flags,
  Stdlib::Absolutepath                $restore_path     = $restic::restore_path,
  Optional[String[1]]                 $restore_pre_cmd  = $restic::restore_pre_cmd,
  Optional[String[1]]                 $restore_post_cmd = $restic::restore_post_cmd,
  Optional[String[1]]                 $restore_snapshot = $restic::restore_snapshot,
  String[1]                           $timer            = $restic::timer,
  String[1]                           $user             = $restic::user,
) {
  assert_private()

  $repository  = "${repository_type}:${repository_host}/${repository_name}"
  $config_file = "/etc/default/restic_${title}"

  if $init_repo {
    exec { "restic_init_${repository}":
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
      mode           => '0644',
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
  }

  if $enable_backup and $backup_path == undef {
    fail("restic::backup[${title}]: You have to set \$backup_path if you enable the backup!")
  }

  ##
  ## backup service
  ##
  $backup_commands = [
    $backup_pre_cmd,
    "${binary} backup \$GLOBAL_FLAGS \$BACKUP_FLAGS",
    $backup_post_cmd,
  ]

  $backup_keys = {
    'BACKUP_FLAGS' => [ $backup_flags, $backup_path ].flatten.join(' '),
  }

  restic::service { "restic_backup_${title}":
    commands => $backup_commands,
    config   => $config_file,
    configs  => $backup_keys,
    enable   => $enable_backup,
    group    => $user,
    timer    => $timer,
    user     => $group,
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
    commands => $forget_commands,
    config   => $config_file,
    configs  => $forget_keys,
    enable   => $enable_forget,
    group    => $user,
    timer    => $forget_timer,
    user     => $group,
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
    commands => $restore_commands,
    config   => $config_file,
    configs  => $restore_keys,
    enable   => $enable_restore,
    group    => $user,
    user     => $group,
  }
}
