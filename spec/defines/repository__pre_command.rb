require 'spec_helper'

describe 'restic::repository::pre_command' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:title) { 'mysql' }

      context 'with simple command' do
        let(:params) { { command: 'xtrabackup --backup --target-dir=/opt/xtrabackup' } }

        it do
          is_expected.to contain_concat__fragment('/lib/systemd/system/restic_backup_mysql.service-pre_commands-188ad9465a3a19dee6c050e682d83127').with(
            {
              'content' => 'ExecStartPre=xtrabackup --backup --target-dir=/opt/xtrabackup',
              'target'  => '/lib/systemd/system/restic_backup_mysql.service',
              'order'   => '11',
            },
          )
        end
      end

      context 'with multiple commands' do
        let(:params) { { command: ['xtrabackup --backup --target-dir=/opt/xtrabackup', 'pg_basebackup --pgdata /opt/pg_basebackup'] } }

        it do
          is_expected.to contain_concat__fragment('/lib/systemd/system/restic_backup_mysql.service-pre_commands-a8620ed190ed1dd9a51618588212720a').with(
            {
              'content' => "ExecStartPre=xtrabackup --backup --target-dir=/opt/xtrabackup\nExecStartPre=pg_basebackup --pgdata /opt/pg_basebackup",
              'target'  => '/lib/systemd/system/restic_backup_mysql.service',
              'order'   => '11',
            },
          )
        end
      end

      ['backup', 'forget', 'restore'].each do |cmd|
        context "with restic_command => '#{cmd}'" do
          let(:params) { { command: 'foo', restic_command: cmd } }

          it do
            is_expected.to contain_concat__fragment("/lib/systemd/system/restic_#{cmd}_mysql.service-pre_commands-acbd18db4cc2f85cedef654fccc4a4d8").with(
              {
                'target' => "/lib/systemd/system/restic_#{cmd}_mysql.service",
              },
            )
          end
        end
      end

      context 'with allow_fail => true' do
        let(:params) { { command: 'foo', allow_fail: true } }

        it do
          is_expected.to contain_concat__fragment('/lib/systemd/system/restic_backup_mysql.service-pre_commands-acbd18db4cc2f85cedef654fccc4a4d8').with(
            {
              'content' => 'ExecStartPre=-foo',
            },
          )
        end
      end

      context 'with order => 13' do
        let(:params) { { command: 'foo', order: 13 } }

        it do
          is_expected.to contain_concat__fragment('/lib/systemd/system/restic_backup_mysql.service-pre_commands-acbd18db4cc2f85cedef654fccc4a4d8').with(
            {
              'order' => '13',
            },
          )
        end
      end
    end
  end
end
