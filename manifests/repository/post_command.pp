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
  $service_title = "restic_${restic_command}_${repository_title}"
  $command_md5   = md5(String($command))
  $_allow_fail = $allow_fail ? {
    true  => '-',
    false => '',
  }
  $_command    = [$command].flatten.map |$c| { "ExecStartPost=${_allow_fail}${c}" }

  concat::fragment { "/lib/systemd/system/${service_title}.service-post_commands-${command_md5}":
    target  => "/lib/systemd/system/${service_title}.service",
    content => $_command.join("\n"),
    order   => String($order),
  }
}
