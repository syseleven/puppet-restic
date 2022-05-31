# frozen_string_literal: true

require 'spec_helper'

defaults = {
  'package_ensure'   => 'present',
  'package_manage'   => true,
  'package_name'     => 'restic',
  'repositories'     => {},
  'backup_flags'     => [],
  'backup_path'      => :undef,
  'backup_pre_cmd'   => :undef,
  'backup_post_cmd'  => :undef,
  'backup_timer'     => :undef,
  'binary'           => '/usr/bin/restic',
  'bucket'           => :undef,
  'enable_backup'    => true,
  'enable_forget'    => false,
  'enable_restore'   => false,
  'forget'           => {},
  'forget_flags'     => [],
  'forget_pre_cmd'   => :undef,
  'forget_post_cmd'  => :undef,
  'forget_timer'     => :undef,
  'global_flags'     => [],
  'group'            => 'root',
  'host'             => :undef,
  'id'               => :undef,
  'init_repo'        => true,
  'key'              => :undef,
  'password'         => :undef,
  'prune'            => false,
  'restore_flags'    => [],
  'restore_path'     => :undef,
  'restore_pre_cmd'  => :undef,
  'restore_post_cmd' => :undef,
  'restore_snapshot' => 'latest',
  'restore_timer'    => :undef,
  'user'             => 'root',
  'type'             => 's3',
}

tests = {
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
}

describe 'restic' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:params) do
        defaults
      end

      tests.each do |title, params|
        context "with #{title}" do
          let(:params) do
            super().merge(params)
          end

          it {
            is_expected.to compile.with_all_deps
          }

          include_examples 'package', params
          include_examples 'reload'

          params['repositories']&.each do |repository, config|
            include_examples 'repository', repository, config, defaults, params

            it {
              is_expected.to contain_class('restic::package').that_comes_before("Restic::Repository[#{repository}]")
            }

            it {
              is_expected.to contain_restic__repository(repository).that_notifies('Class[restic::reload]')
            }
          end
        end
      end
    end
  end
end
