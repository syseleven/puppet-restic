# @summary A data hash with restic backup configuration
#
#
type Restic::Repositories = Hash[
  String[1],
  Struct[
    {
      backup_flags     => Optional[Variant[Array[String[1]],String[1]]],
      backup_path      => Optional[Restic::Path],
      backup_post_cmd  => Optional[String[1]],
      backup_pre_cmd   => Optional[String[1]],
      binary           => Optional[Stdlib::Absolutepath],
      check            => Optional[Boolean],
      enable_backup    => Optional[Boolean],
      enable_forget    => Optional[Boolean],
      enable_restore   => Optional[Boolean],
      forget           => Optional[Restic::Forget],
      forget_flags     => Optional[Variant[Array[String[1]],String[1]]],
      forget_post_cmd  => Optional[String[1]],
      forget_pre_cmd   => Optional[String[1]],
      forget_timer     => Optional[String[1]],
      global_flags     => Optional[Variant[Array[String[1]],String[1]]],
      group            => Optional[String[1]],
      id               => Optional[String[1]],
      init_repo        => Optional[Boolean],
      key              => Optional[String[1]],
      password         => Optional[String[1]],
      prune            => Optional[Boolean],
      repository_host  => Optional[String[1]],
      repository_name  => Optional[String[1]],
      repository_type  => Optional[Restic::Repository::Type],
      restore_flags    => Optional[Variant[Array[String[1]],String[1]]],
      restore_path     => Optional[Stdlib::Absolutepath],
      restore_post_cmd => Optional[String[1]],
      restore_pre_cmd  => Optional[String[1]],
      restore_snapshot => Optional[String[1]],
      timer            => Optional[String[1]],
      user             => Optional[String[1]],
    }
  ]
]
