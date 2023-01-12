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

  # This might seem odd to you, but it's actually thought-out
  # We use a concat resource for the unit file, because it allows people
  # to inject pre/post scripts into the restic backup job. This is helpful
  # if you want to e.g. trigger database backups/cleanups
  concat { "/lib/systemd/system/${title}.service":
    ensure         => $ensure,
    ensure_newline => true,
    owner          => 'root',
    group          => 'root',
    mode           => '0444',
    show_diff      => true,
  }

  concat::fragment { "/lib/systemd/system/${title}.service-base":
    content => epp("${module_name}/restic.service.epp", { config => $config, group => $group, user => $user, }),
    target  => "/lib/systemd/system/${title}.service",
  }

  $commands_template = @(END/L)
  <% $commands.each |$command| { -%>
  ExecStart=<%= $command %>
  <% } -%>
  | END

  concat::fragment { "/lib/systemd/system/${title}.service-commands":
    content => inline_epp($commands_template),
    target  => "/lib/systemd/system/${title}.service",
    order   => '25',
  }

  systemd::unit_file { "${title}.service":
    ensure    => $ensure,
    target    => "/lib/systemd/system/${title}.service",
    group     => 'root',
    mode      => '0440',
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
