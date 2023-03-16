# @summary
#   Provide config for a Restic service
#
# @api private
#
define restic::service::config (
  String[1] $service,
  Enum['present', 'file', 'absent'] $ensure = 'present',
  Optional[String[1]] $group = undef,
  Hash[String[1], Variant[Sensitive[String[1]]], String[1]] $config = {},
) {
  include restic

  $_ensure = boolstr($ensure != 'absent', 'file', 'absent')

  file { "${restic::config_directory}/${title}-${service}.env":
    ensure  => $_ensure,
    owner   => 'root',
    group   => pick($group, $restic::group),
    content => epp("${module_name}/config.env.epp", { 'config' => $config }),
  }
}
