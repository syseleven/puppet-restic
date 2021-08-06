# @summary
#   Configure a restic service
#
# @api private
#
define restic::service (
  $commands,
  $config,
  $configs,
  $enable,
  $group,
  $user,
  $timer = undef,
) {
  assert_private()

  if $enable {
    $configs.each |$key,$data| {
      concat::fragment { "restic_fragment_${title}_${key}":
        content => "${key}='${data}'",
        target  => $config,
      }
    }

    $ensure = 'present'
  } else {
    $ensure = 'absent'
  }

  systemd::unit_file { "${title}.service":
    ensure    => $ensure,
    content   => epp("${module_name}/restic.service.epp", { commands => $commands.delete_undef_values, config => $config, group => $group, user => $user, }),
    group     => 'root',
    mode      => '0444',
    owner     => 'root',
    path      => '/etc/systemd/system',
    show_diff => true,
  }

  if $timer {
    systemd::timer { "${title}.timer":
      ensure        => $ensure,
      active        => $enable,
      enable        => $enable,
      timer_content => epp("${module_name}/restic.timer.epp", { timer => $timer, }),
    }
  }
}
