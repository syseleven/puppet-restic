# @summary
#   Configure the Restic backup service
#
# @api private
#
class restic::service::backup (
  Enum['present', 'absent'] $ensure = 'present',
) {
  assert_private()

  include restic

  restic::service { 'backup':
    ensure => $ensure,
    timer  => $restic::backup_timer,
  }
}
