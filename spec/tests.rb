cmd_tests = {}
[ 'backup_pre_cmd', 'backup_post_cmd', 'forget_pre_cmd', 'forget_post_cmd', 'restore_pre_cmd', 'restore_post_cmd', ].each do |cmd|
  cmd_tests.merge!({
    "#{cmd} string" => {
        'type' => 'rest',
        'backup_path' => '/home/backup',
        'host' => 'https://rest-backup-server',
        'password' => 'some_password_value',
        cmd => 'somecommand',
    },
    "#{cmd} array" => {
        'type' => 'rest',
        'backup_path' => '/home/backup',
        'host' => 'https://rest-backup-server',
        'password' => 'some_password_value',
        cmd => ['some_command_1', 'some_command_2'],
    },
  })
end

TESTS = {
  'default values' => {
    'package_manage' => true,
  },
  'not managing package' => {
    'package_manage' => false,
  },
  'install from url with package_version provided' => {
    'install_method' => 'url',
    'package_version' => '0.14.0',
  },
  'install from url with package_version and checksum provided' => {
    'install_method' => 'url',
    'package_version' => '0.14.0',
    'checksum' => 'c8da7350dc334cd5eaf13b2c9d6e689d51e7377ba1784cc6d65977bd44ee1165',
  },
  'one repo and init' => {
    'repositories' => {
      'initonly' => {
        'bucket' => 'some_bucket_value',
        'enable_backup' => false,
        'host' => 'some_host_value',
        'id' => 'some_id_value',
        'key' => 'some_key_value',
        'password' => 'some_password_value',
      }
    }
  },
  'one repo without init' => {
    'repositories' => {
      'nothing' => {
        'bucket' => 'some_bucket_value',
        'enable_backup' => false,
        'host' => 'some_host_value',
        'id' => 'some_id_value',
        'init_repo' => false,
        'key' => 'some_key_value',
        'password' => 'some_password_value',
      }
    }
  },
  'backup and backup_timer' => {
    'repositories' => {
      'backup1' => {
        'backup_path' => '/home/rspec',
        'backup_timer' => 'Sunday',
        'bucket' => 'some_bucket_value',
        'enable_backup' => true,
        'host' => 'some_host_value',
        'id' => 'some_id_value',
        'key' => 'some_key_value',
        'password' => 'some_password_value',
      }
    }
  },
  'backup and backup_pre_cmd' => {
    'repositories' => {
      'backup2' => {
        'backup_path' => '/home/rspec',
        'backup_timer' => 'Sunday',
        'backup_pre_cmd' => 'touch foo bar',
        'bucket' => 'some_bucket_value',
        'enable_backup' => true,
        'host' => 'some_host_value',
        'id' => 'some_id_value',
        'key' => 'some_key_value',
        'password' => 'some_password_value',
      }
    }
  },
  'restore and restore_timer' => {
    'repositories' => {
      'restore1' => {
        'bucket' => 'some_bucket_value',
        'enable_backup' => false,
        'enable_restore' => true,
        'host' => 'some_host_value',
        'id' => 'some_id_value',
        'key' => 'some_key_value',
        'password' => 'some_password_value',
        'restore_path' => '/home/rspec',
        'restore_timer' => 'Sunday',
      }
    }
  },
  'backup and restore and forget' => {
    'repositories' => {
      'backup3' => {
        'backup_path' => '/home/backup',
        'backup_timer' => 'Monday',
        'bucket' => 'some_bucket_value',
        'enable_backup' => false,
        'enable_forget' => true,
        'enable_restore' => true,
        'forget' => {
          'keep-last' => 120,
        },
        'forget_timer' => 'forget_timer',
        'host' => 'some_host_value',
        'id' => 'some_id_value',
        'key' => 'some_key_value',
        'password' => 'some_password_value',
        'restore_path' => '/home/restore',
        'restore_timer' => 'Sunday',
        'prune' => true,
      }
    }
  },
  'backup with type rest' => {
    'repositories' => {
      'backup1' => {
        'type' => 'rest',
        'backup_path' => '/home/backup',
        'host' => 'https://rest-backup-server',
        'password' => 'some_password_value',
      }
    }
  },
  'backup with backup_exit3_success => true' => {
    'repositories' => {
      'backup1' => {
        'backup_path' => '/home/backup',
        'bucket' => 'some_bucket_value',
        'host' => 'some_host_value',
        'id' => 'some_id_value',
        'key' => 'some_key_value',
        'password' => 'some_password_value',
        'backup_exit3_success' => true,
      }
    }
  },
  'one repo and init with gs backend' => {
    'repositories' => {
      'initonly' => {
        'type' => 'gs',
        'bucket' => 'some_bucket_value',
        'enable_backup' => false,
        'gcs_project_id' => 'some_project_id',
        'gcs_repository' => 'some_gcs_repository',
        'gcs_credentials_path' => '/some/path/to/credentials',
        'password' => 'some_password_value',
      }
    }
  },
  'one repo without init with gs backend' => {
    'repositories' => {
      'nothing' => {
        'type' => 'gs',
        'bucket' => 'some_bucket_value',
        'enable_backup' => false,
        'gcs_project_id' => 'some_project_id',
        'gcs_repository' => 'some_gcs_repository',
        'gcs_credentials_path' => '/some/path/to/credentials',
        'init_repo' => false,
        'password' => 'some_password_value',
      }
    }
  },
  'backup and backup_timer with gs backend' => {
    'repositories' => {
      'backup1' => {
        'type' => 'gs',
        'backup_path' => '/home/rspec',
        'backup_timer' => 'Sunday',
        'bucket' => 'some_bucket_value',
        'enable_backup' => true,
        'gcs_project_id' => 'some_project_id',
        'gcs_repository' => 'some_gcs_repository',
        'gcs_credentials_path' => '/some/path/to/credentials',
        'password' => 'some_password_value',
      }
    }
  },
  'backup and backup_pre_cmd with gs backend' => {
    'repositories' => {
      'backup2' => {
        'type' => 'gs',
        'backup_path' => '/home/rspec',
        'backup_timer' => 'Sunday',
        'backup_pre_cmd' => 'touch foo bar',
        'bucket' => 'some_bucket_value',
        'enable_backup' => true,
        'gcs_project_id' => 'some_project_id',
        'gcs_repository' => 'some_gcs_repository',
        'gcs_credentials_path' => '/some/path/to/credentials',
        'password' => 'some_password_value',
      }
    }
  },
  'restore and restore_timer with gs backend' => {
    'repositories' => {
      'restore1' => {
        'type' => 'gs',
        'bucket' => 'some_bucket_value',
        'enable_backup' => false,
        'enable_restore' => true,
        'gcs_project_id' => 'some_project_id',
        'gcs_repository' => 'some_gcs_repository',
        'gcs_credentials_path' => '/some/path/to/credentials',
        'password' => 'some_password_value',
        'restore_path' => '/home/rspec',
        'restore_timer' => 'Sunday',
      }
    }
  },
  'backup and restore and forget with gs backend' => {
    'repositories' => {
      'backup3' => {
        'type' => 'gs',
        'backup_path' => '/home/backup',
        'backup_timer' => 'Monday',
        'bucket' => 'some_bucket_value',
        'enable_backup' => false,
        'enable_forget' => true,
        'enable_restore' => true,
        'forget' => {
          'keep-last' => 120,
        },
        'forget_timer' => 'forget_timer',
        'gcs_project_id' => 'some_project_id',
        'gcs_repository' => 'some_gcs_repository',
        'gcs_credentials_path' => '/some/path/to/credentials',
        'password' => 'some_password_value',
        'restore_path' => '/home/restore',
        'restore_timer' => 'Sunday',
        'prune' => true,
      }
    }
  },
  'backup with gs backend with backup_exit3_success => true' => {
    'repositories' => {
      'backup1' => {
        'type' => 'gs',
        'backup_path' => '/home/backup',
        'bucket' => 'some_bucket_value',
        'gcs_project_id' => 'some_project_id',
        'gcs_repository' => 'some_gcs_repository',
        'gcs_credentials_path' => '/some/path/to/credentials',
        'password' => 'some_password_value',
        'backup_exit3_success' => true,
      }
    }
  },
  'one repo and init with sftp backend' => {
    'repositories' => {
      'initonly' => {
        'type' => 'sftp',
        'sftp_repository' => 'some_sftp_repository',
        'enable_backup' => false,
        'sftp_user' => 'some_sftp_user',
        'host' => 'some_host_value',
        'password' => 'some_password_value',
      }
    }
  },
  'one repo without init with sftp backend' => {
    'repositories' => {
      'nothing' => {
        'type' => 'sftp',
        'sftp_repository' => 'some_sftp_repository',
        'enable_backup' => false,
        'sftp_user' => 'some_sftp_user',
        'sftp_port' => '2222',
        'init_repo' => false,
        'password' => 'some_password_value',
      }
    }
  },
  'backup and backup_timer with sftp backend' => {
    'repositories' => {
      'backup1' => {
        'type' => 'sftp',
        'backup_path' => '/home/rspec',
        'backup_timer' => 'Sunday',
        'sftp_repository' => 'some_sftp_repository',
        'enable_backup' => true,
        'sftp_user' => 'some_sftp_user',
        'host' => 'some_host_value',
        'password' => 'some_password_value',
      }
    }
  },
  'backup and backup_pre_cmd with sftp backend' => {
    'repositories' => {
      'backup2' => {
        'type' => 'sftp',
        'backup_path' => '/home/rspec',
        'backup_timer' => 'Sunday',
        'backup_pre_cmd' => 'touch foo bar',
        'sftp_repository' => 'some_sftp_repository',
        'enable_backup' => true,
        'sftp_user' => 'some_sftp_user',
        'host' => 'some_host_value',
        'sftp_port' => '2222',
        'password' => 'some_password_value',
      }
    }
  },
  'restore and restore_timer with sftp backend' => {
    'repositories' => {
      'restore1' => {
        'type' => 'sftp',
        'sftp_repository' => 'some_sftp_repository',
        'enable_backup' => false,
        'enable_restore' => true,
        'sftp_user' => 'some_sftp_user',
        'host' => 'some_host_value',
        'password' => 'some_password_value',
        'restore_path' => '/home/rspec',
        'restore_timer' => 'Sunday',
      }
    }
  },
  'backup and restore and forget with sftp backend' => {
    'repositories' => {
      'backup3' => {
        'type' => 'sftp',
        'backup_path' => '/home/backup',
        'backup_timer' => 'Monday',
        'sftp_repository' => 'some_sftp_repository',
        'enable_backup' => false,
        'enable_forget' => true,
        'enable_restore' => true,
        'forget' => {
          'keep-last' => 120,
        },
        'forget_timer' => 'forget_timer',
        'sftp_user' => 'some_sftp_user',
        'host' => 'some_host_value',
        'sftp_port' => '2222',
        'password' => 'some_password_value',
        'restore_path' => '/home/restore',
        'restore_timer' => 'Sunday',
        'prune' => true,
      }
    }
  },
  'backup with sftp backend with backup_exit3_success => true' => {
    'repositories' => {
      'backup1' => {
        'type' => 'sftp',
        'backup_path' => '/home/backup',
        'sftp_repository' => 'some_sftp_repository',
        'sftp_user' => 'some_sftp_user',
        'host' => 'some_host_value',
        'password' => 'some_password_value',
        'backup_exit3_success' => true,
      }
    }
  },
}.merge(cmd_tests).freeze
