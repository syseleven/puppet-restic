# @summary A data hash with restic backup configuration
#
#
type Restic::Repositories = Hash[
  String[1],
  Struct[
    {
      backup_exit3_success => Optional[Boolean],
      backup_flags         => Optional[Variant[Array[String[1]],String[1]]],
      backup_path          => Optional[Restic::Path],
      backup_post_cmd      => Optional[Variant[Array[String[1]],String[1]]],
      backup_pre_cmd       => Optional[Variant[Array[String[1]],String[1]]],
      backup_timer         => Optional[String[1]],
      binary               => Optional[Stdlib::Absolutepath],
      bucket               => Optional[String],
      enable_backup        => Optional[Boolean],
      enable_forget        => Optional[Boolean],
      enable_restore       => Optional[Boolean],
      forget               => Optional[Restic::Forget],
      forget_flags         => Optional[Variant[Array[String[1]],String[1]]],
      forget_post_cmd      => Optional[Variant[Array[String[1]],String[1]]],
      forget_pre_cmd       => Optional[Variant[Array[String[1]],String[1]]],
      forget_timer         => Optional[String[1]],
      global_flags         => Optional[Variant[Array[String[1]],String[1]]],
      gcs_credentials_path => Optional[Stdlib::Absolutepath],
      gcs_project_id       => Optional[Variant[Sensitive[String],String]],
      gcs_repository       => Optional[Variant[Sensitive[String],String]],
      group                => Optional[String],
      host                 => Optional[Variant[Sensitive[String],String]],
      id                   => Optional[Variant[Sensitive[String],String]],
      init_repo            => Optional[Boolean],
      key                  => Optional[Variant[Sensitive[String],String]],
      password             => Optional[Variant[Sensitive[String],String]],
      prune                => Optional[Boolean],
      restore_flags        => Optional[Variant[Array[String[1]],String[1]]],
      restore_path         => Optional[Stdlib::Absolutepath],
      restore_post_cmd     => Optional[Variant[Array[String[1]],String[1]]],
      restore_pre_cmd      => Optional[Variant[Array[String[1]],String[1]]],
      restore_snapshot     => Optional[String[1]],
      restore_timer        => Optional[String[1]],
      sftp_port            => Optional[String],
      sftp_user            => Optional[String],
      type                 => Optional[Restic::Repository::Type],
      user                 => Optional[String[1]],
    }
  ]
]
