# @summary Configure restic service
# @api private
class restic::config {
  include restic
  require restic::package

  if $restic::manage_group {
    group { $restic::group:
      ensure => present,
      system => true,
    }
  }

  if $restic::manage_user {
    user { $restic::user:
      ensure => present,
      gid    => $restic::group,
      system => true,
      home   => $restic::user_homedir,
      shell  => '/usr/sbin/nologin',
    }
  }

  if $restic::manage_user_homedir {
    file { $restic::user_homedir:
      ensure => directory,
      owner  => $restic::user,
      group  => $restic::group,
      mode   => '0750',
    }
  }

  file { $restic::config_directory:
    ensure => directory,
    owner  => 'root',
    group  => $restic::group,
    mode   => '0750',
  }
}
