# @summary Define command(s) to be run before a restic command
#
# @param command Command to run.
# @param repository_title restic::repository title where this command should be add to.
# @param restic_command Before which restic command this command should be run.
# @param allow_fail If an error of this commands should be allowed.
# @param order Order of Commands. Helpful if you have multiple.
#
# @example Define a command to be run before the backup
#   restic::repository::pre_command { 'mysql':
#     command => 'xtrabackup --backup --target-dir=/opt/xtrabackup',
#   }
#
define restic::repository::pre_command (
  Variant[Array[String[1]],String[1]] $command,
  String[1]                           $repository_title = $title,
  Enum['backup', 'forget', 'restore'] $restic_command  = 'backup',
  Boolean                             $allow_fail      = false,
  Integer[11,24]                      $order           = 11,
) {
  $service_title = "restic_${restic_command}_${repository_title}"
  $command_md5   = md5(String($command))
  $_command      = [ $command, ].flatten.map |$c| { "ExecStartPre=${_allow_fail}${c}" }
  $_allow_fail   = $allow_fail ? {
    true  => '-',
    false => '',
  }

  concat::fragment { "/lib/systemd/system/${service_title}.service-pre_commands-${command_md5}":
    target  => "/lib/systemd/system/${service_title}.service",
    content => $_command.join("\n"),
    order   => String($order),
  }
}
