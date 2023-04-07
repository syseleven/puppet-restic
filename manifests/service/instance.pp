# @summary
#   Manage a service instance
#
# @example Backup service
#   restic::service::instance { 'backup-myrepo':
#     'commands' => ['restic backup'],
#   }
#
# @api private
define restic::service::instance (
  Array[String, 1] $commands,
  Optional[String[1]] $timer = undef,
  Enum['present', 'absent'] $ensure = 'present',
  Enum['backup', 'forget', 'restore'] $service = $title.split('-')[0],
  String[1] $repository = $title.split('-')[1],
  Optional[String[1]] $user = undef,
  Optional[String[1]] $group = undef,
  Hash[String[1], Variant[Sensitive[String], String]] $config = {},
  Hash $service_entry = {},
) {
  assert_private()

  include restic

  if $ensure == 'present' and $timer =~ Undef and getvar("restic::${service}_timer") =~ Undef {
    fail("Restic::Service::Instance[${name}] A timer must be provided")
  }

  $common_config_file = "${restic::config_directory}/${repository}.env"
  $service_config_file = "${restic::config_directory}/${repository}-${service}.env"

  include "restic::service::${service}"

  $_service_entry = {
    'User'      => $user,
    'Group'     => $group,
    'ExecStart' => $commands,
    # TODO: AmbientCapabilities=CAP_DAC_READ_SEARCH
  } + $service_entry

  systemd::manage_dropin { "restic-${service}-${repository}.service":
    ensure        => $ensure,
    filename      => 'puppet.conf',
    unit          => "restic-${service}@${repository}.service",
    service_entry => $_service_entry.delete_undef_values,
    require       => Class['restic::service::backup'],
  }

  file { $service_config_file:
    ensure  => bool2str($ensure == 'present' and !$config.empty, 'file', 'absent'),
    owner   => 'root',
    group   => pick($group, $restic::group),
    content => epp("${module_name}/config.env.epp", { 'config' => $config }),
  }

  systemd::manage_dropin { "restic-${service}-${repository}.timer":
    ensure      => bool2str($ensure == 'present' and $timer =~ NotUndef, 'present', 'absent'),
    filename    => 'puppet.conf',
    unit        => "restic-${service}@${repository}.timer",
    timer_entry => {
      # TODO: if set to absent, the type is still validated
      'OnCalendar' => $timer.lest || { '' },
    },
    require     => Class['restic::service::backup'],
  }

  service { "restic-${service}@${repository}.timer":
    ensure    => bool2str($ensure == 'present', 'running', 'stopped'),
    enable    => $ensure == 'present',
    require   => [Concat[$common_config_file], File[$service_config_file]],
    subscribe => Systemd::Manage_dropin["restic-${service}-${repository}.service", "restic-${service}-${repository}.timer"],
  }
}
