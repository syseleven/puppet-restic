# @summary
#   Configure the Restic restore service
#
# @api private
#
class restic::service::restore (
  Enum['present', 'absent'] $ensure = 'present',
) {
  assert_private()

  restic::service { 'restore':
    ensure   => $ensure,
  }
}
