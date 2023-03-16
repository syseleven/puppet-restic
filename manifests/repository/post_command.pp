# @summary Define command(s) to be run after a restic command
#
# @param command Command to run.
# @param repository_title restic::repository title where this command should be add to.
# @param restic_command After which restic command this command should be run.
# @param allow_fail If an error of this commands should be allowed.
# @param order Order of Commands. Helpful if you have multiple.
#
# @example Define a command to be run after the backup
#   restic::repository::pre_command { 'mysql':
#     command => 'rm -rf /opt/xtrabackup',
#   }
define restic::repository::post_command (
  Variant[Array[String[1]],String[1]] $command,
  String[1]                           $repository_title = $title,
  Enum['backup', 'forget', 'restore'] $restic_command  = 'backup',
  Boolean                             $allow_fail      = false,
  Integer[26]                         $order           = 26,
) {
  $_allow_fail = bool2str($allow_fail, '-', '')

  systemd::manage_dropin { "restic-post_command-${restic_command}-${title}":
    unit          => "restic-${restic_command}@${repository_title}.service",
    # TODO: include order?
    filename      => "post-${title}.conf",
    service_entry => {
      'ExecStartPost' => Array($command).map |$c| { "${_allow_fail}${c}" },
    },
  }
}
