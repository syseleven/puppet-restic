# frozen_string_literal: true

shared_examples 'reload' do ||
  # defaults = {
  # }
  #
  # params = defaults.merge(params)

  it {
    is_expected.to contain_exec('systemctl_daemon_reload_restic').only_with(
      {
        'command' => 'systemctl daemon-reload',
        'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'refreshonly' => true,
      },
    )
  }
end
