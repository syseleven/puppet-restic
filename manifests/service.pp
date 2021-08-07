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
  $timer,
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
    content   => epp("${module_name}/restic.service.epp", { commands => $commands, config => $config, group => $group, user => $user, }),
    group     => 'root',
    mode      => '0444',
    owner     => 'root',
    path      => '/etc/systemd/system',
    show_diff => true,
  }

  $timer_ensure = $timer ? {
    String => $ensure,
    Undef  => 'absent',
  }

  $timer_enable = $timer ? {
    String => $enable,
    Undef  => false,
  }

  $timer_content = $timer ? {
    String => epp("${module_name}/restic.timer.epp", { timer => $timer, }),
    Undef  => undef,
  }

  systemd::timer { "${title}.timer":
    ensure        => $timer_ensure,
    active        => $timer_enable,
    enable        => $timer_enable,
    timer_content => $timer_content,
  }
}
