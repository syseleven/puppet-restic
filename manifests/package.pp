# @summary
#   Install restic packages
#
# @api private
#
class restic::package (
  $package_ensure  = $restic::package_ensure,
  $package_manage  = $restic::package_manage,
  $package_name    = $restic::package_name,
  $package_version = $restic::package_version,
  $checksum        = $restic::checksum,
  $install_method  = $restic::install_method,
) {
  assert_private()

  case $install_method {
    'package': {
      if $package_manage {
        package { $package_name:
          ensure => $package_ensure,
        }
      }
    }
    'url': {
      assert_type(String[1], $package_version) |$a, $b| {
        fail('$package_version is required when using $install_method == "url"')
      }

      $checksum_type = $checksum ? {
        undef   => undef,
        default => 'sha256',
      }

      package { 'bzip2':
        ensure => present,
      }
      -> archive { "restic-${package_version}.bz2":
        path            => "/tmp/restic-${package_version}.bz2",
        source          => "https://github.com/restic/restic/releases/download/v${package_version}/restic_${package_version}_linux_amd64.bz2",
        checksum        => $checksum,
        checksum_type   => $checksum_type,
        extract         => true,
        extract_path    => '/usr/local/bin',
        extract_command => "bunzip2 -cd %s > /usr/local/bin/restic-${package_version}",
        creates         => "/usr/local/bin/restic-${package_version}",
        cleanup         => true,
      }
      -> file { "/usr/local/bin/restic-${package_version}":
        ensure => file,
        mode   => '0555',
        owner  => 'root',
        group  => 'root',
      }
      -> file { '/usr/local/bin/restic':
        ensure => link,
        target => "/usr/local/bin/restic-${package_version}",
      }
    }
    default: {
      fail("install_method: '${install_method}' not available.")
    }
  }
}
