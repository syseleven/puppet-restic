require 'spec_helper'

describe 'restic::repository::post_command' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:title) { 'mysql' }

      context 'with simple command' do
        let(:params) { { command: 'rm -rf /opt/xtrabackup' } }

        it do
          is_expected.to contain_concat__fragment('/lib/systemd/system/restic_backup_mysql.service-post_commands-998376aa91119c20e9fde3d81bc7bb62').with(
            {
              'content' => 'ExecStartPost=rm -rf /opt/xtrabackup',
              'target'  => '/lib/systemd/system/restic_backup_mysql.service',
              'order'   => '26',
            },
          )
        end
      end

      context 'with multiple commands' do
        let(:params) { { command: ['rm -rf /opt/xtrabackup', 'rm -rf /opt/pg_basebackup'] } }

        it do
          is_expected.to contain_concat__fragment('/lib/systemd/system/restic_backup_mysql.service-post_commands-68568f50817ee2fdf3a463036431fcda').with(
            {
              'content' => "ExecStartPost=rm -rf /opt/xtrabackup\nExecStartPost=rm -rf /opt/pg_basebackup",
              'target'  => '/lib/systemd/system/restic_backup_mysql.service',
              'order'   => '26',
            },
          )
        end
      end

      ['backup', 'forget', 'restore'].each do |cmd|
        context "with restic_command => '#{cmd}'" do
          let(:params) { { command: 'foo', restic_command: cmd } }

          it do
            is_expected.to contain_concat__fragment("/lib/systemd/system/restic_#{cmd}_mysql.service-post_commands-acbd18db4cc2f85cedef654fccc4a4d8").with(
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
          is_expected.to contain_concat__fragment('/lib/systemd/system/restic_backup_mysql.service-post_commands-acbd18db4cc2f85cedef654fccc4a4d8').with(
            {
              'content' => 'ExecStartPost=-foo',
            },
          )
        end
      end

      context 'with order => 27' do
        let(:params) { { command: 'foo', order: 27 } }

        it do
          is_expected.to contain_concat__fragment('/lib/systemd/system/restic_backup_mysql.service-post_commands-acbd18db4cc2f85cedef654fccc4a4d8').with(
            {
              'order' => '27',
            },
          )
        end
      end
    end
  end
end
