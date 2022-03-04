# frozen_string_literal: true

shared_examples 'service' do |title, commands, config, configs, enable, group, user, timer = :undef|
  it {
    is_expected.to contain_restic__service(title).with(
      {
        'commands' => commands,
        'config'   => config,
        'configs'  => configs,
        'enable'   => enable,
        'group'    => group,
        'user'     => user,
        'timer'    => if timer == :undef
                        nil
                      else
                        timer
                      end,
      },
    )
  }

  if enable
    configs.each do |key, data|
      it {
        is_expected.to contain_concat__fragment("restic_fragment_#{title}_#{key}").with(
          {
            'content' => "#{key}='#{data}'",
            'target'  => config,
          },
        )
      }
    end

    ensure_value = 'present'
  else
    ensure_value = 'absent'
  end

  service_content = [
    '[Service]',
    "User=#{user}",
    "Group=#{group}",
    'Type=oneshot',
    "EnvironmentFile=#{config}",
  ]

  commands.delete(:undef)
  commands.delete(nil)

  commands.each do |command|
    service_content << "ExecStart=#{command}"
  end

  service_content << ''

  it {
    is_expected.to contain_systemd__unit_file("#{title}.service").with(
      {
        'ensure'    => ensure_value,
        'content'   => service_content.join("\n"),
        'group'     => 'root',
        'mode'      => '0440',
        'owner'     => 'root',
        'path'      => '/etc/systemd/system',
        'show_diff' => true,
      },
    )
  }

  if timer == :undef
    timer_ensure = 'absent'
    timer_enable = false
    timer_content = nil
  else
    timer_ensure = ensure_value
    timer_enable = enable
    timer_content = [
      '[Timer]',
      "OnCalendar=#{timer}",
      '',
    ].join("\n")
  end

  it {
    is_expected.to contain_systemd__timer("#{title}.timer").with(
      {
        'ensure'        => timer_ensure,
        'active'        => timer_enable,
        'enable'        => timer_enable,
        'timer_content' => timer_content,
      },
    )
  }
end
