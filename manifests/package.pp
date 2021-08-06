# @summary
#   Install restic packages
#
# @api private
#
class restic::package (
  $package_ensure = $restic::package_ensure,
  $package_manage = $restic::package_manage,
  $package_name   = $restic::package_name,
) {
  assert_private()

  if $package_manage {
    package { $package_name:
      ensure => $package_ensure,
    }
  }
}
