# @summary
#   Configure the Restic forget service
#
# @api private
#
class restic::service::forget (
  Enum['present', 'absent'] $ensure = 'present',
) {
  assert_private()

  restic::service { 'forget':
    ensure   => $ensure,
  }
}
