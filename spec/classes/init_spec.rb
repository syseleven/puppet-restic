# frozen_string_literal: true

require 'spec_helper'

describe 'restic' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with default value' do
        it {
          is_expected.to compile.with_all_deps
          is_expected.to contain_class('restic::reload')
          is_expected.to contain_class('restic::package')
          is_expected.to contain_exec('systemctl_daemon_reload_restic')
          is_expected.to contain_package('restic')
        }
      end

      context 'with one backup given - no values from main class' do
        let(:params) do
          {
            'repositories' => {
              'backup1' => {
                'id' => 'id',
                'key' => 'key',
                'backup_path' => '/some/absolute/path',
                'repository_type' => 's3',
                'repository_host' => 'some.host.foo',
                'repository_name' => 'repo/name',
                'password' => 'password',
                'timer' => 'Mon..Sun *:00:00',
                'enable_forget' => true,
                'prune' => true,
                'forget' => {
                  'keep-last' => 120,
                },
              },
            },
          }
        end

        it {
          is_expected.to compile.with_all_deps
          is_expected.to contain_concat__fragment('restic_fragment_backup1_AWS_ACCESS_KEY_ID')
          is_expected.to contain_concat__fragment('restic_fragment_backup1_AWS_SECRET_ACCESS_KEY')
          is_expected.to contain_concat__fragment('restic_fragment_backup1_GLOBAL_FLAGS')
          is_expected.to contain_concat__fragment('restic_fragment_backup1_RESTIC_PASSWORD')
          is_expected.to contain_concat__fragment('restic_fragment_backup1_RESTIC_REPOSITORY')
          is_expected.to contain_concat__fragment('restic_fragment_restic_backup_backup1_BACKUP_FLAGS')
          is_expected.to contain_concat__fragment('restic_fragment_restic_forget_backup1_FORGET_FLAGS')
          is_expected.to contain_concat('/etc/default/restic_backup1')
          is_expected.to contain_exec('restic_init_s3:some.host.foo/repo/name')
          is_expected.to contain_restic__repository('backup1')
          is_expected.to contain_restic__service('restic_backup_backup1')
          is_expected.to contain_restic__service('restic_forget_backup1')
          is_expected.to contain_restic__service('restic_restore_backup1')
          is_expected.to contain_systemd__timer('restic_backup_backup1.timer')
          is_expected.to contain_systemd__timer('restic_forget_backup1.timer')
          is_expected.to contain_systemd__unit_file('restic_backup_backup1.service')
          is_expected.to contain_systemd__unit_file('restic_forget_backup1.service')
          is_expected.to contain_systemd__unit_file('restic_restore_backup1.service')
        }
      end

      context 'with one backup given - values from main class' do
        let(:params) do
          {
            'id' => 'id',
            'key' => 'key',
            'repository_host' => 'some.host.foo',
            'repository_type' => 's3',
            'repositories' => {
              'backup2' => {
                'backup_path' => '/some/absolute/path',
                'repository_name' => 'repo/name',
                'password' => 'password',
                'timer' => 'Mon..Sun *:00:00',
                'prune' => true,
                'forget' => {
                  'keep-last' => 120,
                },
              },
            },
          }
        end

        it {
          is_expected.to compile.with_all_deps
          is_expected.to contain_concat__fragment('restic_fragment_backup2_AWS_ACCESS_KEY_ID')
          is_expected.to contain_concat__fragment('restic_fragment_backup2_AWS_SECRET_ACCESS_KEY')
          is_expected.to contain_concat__fragment('restic_fragment_backup2_GLOBAL_FLAGS')
          is_expected.to contain_concat__fragment('restic_fragment_backup2_RESTIC_PASSWORD')
          is_expected.to contain_concat__fragment('restic_fragment_backup2_RESTIC_REPOSITORY')
          is_expected.to contain_concat__fragment('restic_fragment_restic_backup_backup2_BACKUP_FLAGS')
          is_expected.to contain_concat('/etc/default/restic_backup2')
          is_expected.to contain_exec('restic_init_s3:some.host.foo/repo/name')
          is_expected.to contain_restic__repository('backup2')
          is_expected.to contain_restic__service('restic_backup_backup2')
          is_expected.to contain_restic__service('restic_forget_backup2')
          is_expected.to contain_restic__service('restic_restore_backup2')
          is_expected.to contain_systemd__timer('restic_backup_backup2.timer')
          is_expected.to contain_systemd__timer('restic_forget_backup2.timer')
          is_expected.to contain_systemd__unit_file('restic_backup_backup2.service')
          is_expected.to contain_systemd__unit_file('restic_forget_backup2.service')
          is_expected.to contain_systemd__unit_file('restic_restore_backup2.service')
        }
      end

      context 'with one restore given' do
        let(:params) do
          {
            'id' => 'id',
            'init_repo' => false,
            'key' => 'key',
            'repository_host' => 'some.host.foo',
            'repository_type' => 's3',
            'repositories' => {
              'restore1' => {
                'enable_backup' => false,
                'enable_restore' => true,
                'restore_path' => '/some/absolute/path',
                'repository_name' => 'repo/name',
                'password' => 'password',
                'restore_snapshot' => 'snapshot_id',
              },
            },
          }
        end

        it {
          is_expected.to compile.with_all_deps
          is_expected.to contain_concat__fragment('restic_fragment_restic_restore_restore1_RESTORE_FLAGS')
          is_expected.to contain_concat__fragment('restic_fragment_restore1_AWS_ACCESS_KEY_ID')
          is_expected.to contain_concat__fragment('restic_fragment_restore1_AWS_SECRET_ACCESS_KEY')
          is_expected.to contain_concat__fragment('restic_fragment_restore1_GLOBAL_FLAGS')
          is_expected.to contain_concat__fragment('restic_fragment_restore1_RESTIC_PASSWORD')
          is_expected.to contain_concat__fragment('restic_fragment_restore1_RESTIC_REPOSITORY')
          is_expected.to contain_concat('/etc/default/restic_restore1')
          is_expected.to contain_restic__repository('restore1')
          is_expected.to contain_restic__service('restic_backup_restore1')
          is_expected.to contain_restic__service('restic_forget_restore1')
          is_expected.to contain_restic__service('restic_restore_restore1')
          is_expected.to contain_Systemd__timer('restic_backup_restore1.timer')
          is_expected.to contain_Systemd__timer('restic_forget_restore1.timer')
          is_expected.to contain_Systemd__unit_file('restic_backup_restore1.service')
          is_expected.to contain_Systemd__unit_file('restic_forget_restore1.service')
          is_expected.to contain_systemd__unit_file('restic_restore_restore1.service')
        }
      end
    end
  end
end
