# @summary
#   Module to manage restic repositories via systemd service/timer.
#
# @param package_ensure
#   Version for Restic to be installed
#
# @param package_manage
#   Enable Restic package management
#
# @param package_name
#   Name for Restic package
#
# @param package_version
#   Restic version when installing with the `url` method.
#
# @param checksum
#   Checksum of the Restic archive. Only applicable when using `install_method = 'url'`.
#
# @param install_method
#   Install method to use.
#
# @param repositories
#   Hash of repositoriries
#
# @param backup_flags
#   Default flags for `restic backup <flags>`. See `restic backup --help`
#
# @param backup_path
#   Default directory to backed up
#
# @param backup_pre_cmd
#   Default command to run before `restic backup`
#
# @param backup_post_cmd
#   Default command to run after `restic backup`
#
# @param backup_timer
#   Default systemd timer for backup see: https://wiki.archlinux.de/title/Systemd/Timers
#
# @param backup_exit3_success
#   Consider restic's exit code 3 as success. https://restic.readthedocs.io/en/latest/040_backup.html#exit-status-codes
#
# @param binary
#   Default path to the Restic binary
#
# @param bucket
#   Default name for the Restic repository
#
# @param enable_backup
#   Default enable the backup service
#
# @param enable_forget
#   Default enable the forget service
#
# @param enable_restore
#   Default enable the restore service
#
# @param forget
#   Default hash with `keep-*` => `value` to configure forget flags
#
# @param forget_flags
#   Default flags for `restic forget <flags>`. See `restic forget --help`
#
# @param forget_pre_cmd
#   Default command to run before `restic forget`
#
# @param forget_post_cmd
#   Default command to run after `restic forget`
#
# @param forget_timer
#   Default systemd timer for forget see: https://wiki.archlinux.de/title/Systemd/Timers
#
# @param global_flags
#   Default global flags for `restic <flags>`. See `restic --help`
#
# @param gcs_credentials_path
#   Default path to the file containing the Google Cloud service account credentials which allows access to the bucket. Need to be downloaded from Google Cloud see: https://cloud.google.com/iam/docs/service-account-creds
#
# @param gcs_project_id
#   Default Google Cloud project id see: https://cloud.google.com/resource-manager/docs/creating-managing-projects
#
# @param gcs_repository
#   Default repository name used in Google Cloud Storage buckets
#
# @param group
#   Default group for systemd services
#
# @param host
#   Default hostname for the Restic repository
#
# @param id
#   Default S3 storage id for an S3 bucket
#
# @param init_repo
#   Default enable the initialization of the repository
#
# @param key
#   Default S3 storage key for an S3 bucket
#
# @param password
#   Default encryption password for the Restic repository
#
# @param prune
#   Default enable `--prune` flag for `restic forget`
#
# @param restore_flags
#   Default flags for `restic restore <flags>`. See `restic restore --help`
#
# @param restore_path
#   Default directory used to restore a backup
#
# @param restore_pre_cmd command to run before execute restore
#   Default command to run before `restic restore`
#
# @param restore_post_cmd command to run after execute restore
#   Default command to run after `restic restore`
#
# @param restore_snapshot
#   Default Restic snapshot id used by the restore
#
# @param restore_timer
#   Default systemd timer for restore see: https://wiki.archlinux.de/title/Systemd/Timers
#
# @param sftp_port
#   The port used to connect with sft. If the port is 22, this does not need to be filled in as Restic automatically uses this port
#
# @param sftp_repository
#  The path to the repository on the SFTP server
#
# @param sftp_user
#   The user who connects to the SFTP repository
#
# @param type
#   Default name for the Restic repository.
#
# @param user
#   Default user for systemd services
#
class restic (
  ##
  ## package
  ##
  String                              $package_ensure   = 'present',
  Boolean                             $package_manage   = true,
  String                              $package_name     = 'restic',
  Optional[String[1]]                 $package_version  = undef,
  Optional[String[1]]                 $checksum         = undef,
  Enum['package', 'url']              $install_method   = 'package',

  ##
  ## backups/forgets/restores
  ##
  Restic::Repositories                $repositories     = {},

  ##
  ## default values for restic::repositories
  ##
  Variant[Array[String[1]],String[1]]           $backup_flags         = [],
  Optional[Restic::Path]                        $backup_path          = undef,
  Optional[Variant[Array[String[1]],String[1]]] $backup_pre_cmd       = undef,
  Optional[Variant[Array[String[1]],String[1]]] $backup_post_cmd      = undef,
  Optional[String[1]]                           $backup_timer         = undef,
  Boolean                                       $backup_exit3_success = false,
  Stdlib::Absolutepath                          $binary               = '/usr/bin/restic',
  Optional[String]                              $bucket               = undef,
  Boolean                                       $enable_backup        = true,
  Boolean                                       $enable_forget        = false,
  Boolean                                       $enable_restore       = false,
  Restic::Forget                                $forget               = {},
  Variant[Array[String[1]],String[1]]           $forget_flags         = [],
  Optional[Variant[Array[String[1]],String[1]]] $forget_pre_cmd       = undef,
  Optional[Variant[Array[String[1]],String[1]]] $forget_post_cmd      = undef,
  Optional[String[1]]                           $forget_timer         = undef,
  Variant[Array[String[1]],String[1]]           $global_flags         = [],
  Optional[Stdlib::Absolutepath]                $gcs_credentials_path = undef,
  Optional[Variant[Sensitive[String],String]]   $gcs_project_id       = undef,
  Optional[Variant[Sensitive[String],String]]   $gcs_repository       = undef,
  String                                        $group                = 'root',
  Optional[Variant[Sensitive[String],String]]   $host                 = undef,
  Optional[Variant[Sensitive[String],String]]   $id                   = undef,
  Boolean                                       $init_repo            = true,
  Optional[Variant[Sensitive[String],String]]   $key                  = undef,
  Optional[Variant[Sensitive[String],String]]   $password             = undef,
  Boolean                                       $prune                = false,
  Variant[Array[String[1]],String[1]]           $restore_flags        = [],
  Optional[Stdlib::Absolutepath]                $restore_path         = undef,
  Optional[Variant[Array[String[1]],String[1]]] $restore_pre_cmd      = undef,
  Optional[Variant[Array[String[1]],String[1]]] $restore_post_cmd     = undef,
  String[1]                                     $restore_snapshot     = 'latest',
  Optional[String[1]]                           $restore_timer        = undef,
  Optional[Variant[Sensitive[String],String]]   $sftp_port            = undef,
  Optional[Variant[Sensitive[String],String]]   $sftp_repository      = undef,
  Optional[Variant[Sensitive[String],String]]   $sftp_user            = undef,
  Restic::Repository::Type                      $type                 = 's3',
  String[1]                                     $user                 = 'root',
) {
  contain restic::package
  contain restic::reload

  $repositories.each |$repository, $config| {
    restic::repository { $repository:
      * => $config,
    }

    Class['restic::package'] -> Restic::Repository[$repository] ~> Class['restic::reload']
  }
}
