# @summary
#   Reload systemd via `systemctl daemon-reload`
#
# @api private
#
class restic::reload (
) {
  assert_private()

  exec { 'systemctl_daemon_reload_restic':
    command     => 'systemctl daemon-reload',
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    refreshonly => true,
  }
}
