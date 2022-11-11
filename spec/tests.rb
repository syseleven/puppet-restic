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
  }
}.merge(cmd_tests).freeze
