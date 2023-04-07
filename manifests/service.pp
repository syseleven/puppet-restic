# @summary
#   Configure the restic service
#
# @api private
#
define restic::service (
  Enum['present', 'absent'] $ensure = 'present',
  Optional[String[1]] $timer = undef,
) {
  assert_private()

  require restic::config

  $service = "restic-${title}@"

  systemd::manage_unit { "${service}.service":
    ensure        => $ensure,
    unit_entry    => {
      'Description' => "Restic ${title} on %I",
      'After'       => 'network-online.target',
    },
    service_entry => {
      'User'            => $restic::user,
      'Group'           => $restic::group,
      'Type'            => 'oneshot',
      'EnvironmentFile' => [
        "${restic::config_directory}/%I.env",
        "-${restic::config_directory}/%I-${title}.env",
      ],
    },
  }

  systemd::timer { "${service}.timer":
    ensure        => $ensure,
    timer_content => epp("${module_name}/restic@.timer.epp", { 'service' => $service, 'timer' => $timer }),
  }
}
