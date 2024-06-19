# frozen_string_literal: true

shared_examples 'service' do |title, commands, config, configs, enable, group, user, timer = :undef, timer_random_delay = :undef, success_exit_status = :undef|
  it {
    is_expected.to contain_restic__service(title).with(
      {
        'commands'           => commands,
        'config'             => config,
        'configs'            => configs,
        'enable'             => enable,
        'group'              => group,
        'user'               => user,
        'timer'              => if timer == :undef
                                  nil
                                else
                                  timer
                                end,
        'timer_random_delay' => if timer_random_delay == :undef
                                  nil
                                else
                                  timer_random_delay
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

  it {
    is_expected.to contain_concat("/lib/systemd/system/#{title}.service").with(
      {
        'ensure'         => ensure_value,
        'ensure_newline' => true,
        'owner'          => 'root',
        'group'          => 'root',
        'mode'           => '0444',
        'show_diff'      => true,
      },
    )
  }

  if success_exit_status == :undef
    fragment_content = <<~HEREDOC
                     [Service]
                     User=#{user}
                     Group=#{group}
                     Type=oneshot
                     EnvironmentFile=#{config}
                     HEREDOC
  else
    fragment_content = <<~HEREDOC
                     [Service]
                     User=#{user}
                     Group=#{group}
                     Type=oneshot
                     EnvironmentFile=#{config}
                     SuccessExitStatus=3
                     HEREDOC
  end

  it {
    is_expected.to contain_concat__fragment("/lib/systemd/system/#{title}.service-base").with(
      {
        'target'  => "/lib/systemd/system/#{title}.service",
        'content' => fragment_content
      },
    )
  }

  commands.delete(:undef)
  commands.delete(nil)
  it {
    is_expected.to contain_concat__fragment("/lib/systemd/system/#{title}.service-commands").with(
      {
        'target'  => "/lib/systemd/system/#{title}.service",
        'content' => commands.map {|command| "ExecStart=#{command}"}.push('').join("\n")
      },
    )
  }

  it {
    is_expected.to contain_systemd__unit_file("#{title}.service").with(
      {
        'ensure'    => ensure_value,
        'target'    => "/lib/systemd/system/#{title}.service",
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
    if timer_random_delay == :undef
      timer_content = <<~HEREDOC
                      [Timer]
                      OnCalendar=#{timer}

                      [Install]
                      WantedBy=timers.target
                      HEREDOC
    else
      timer_content = <<~HEREDOC
                      [Timer]
                      OnCalendar=#{timer}
                      RandomizedDelaySec=#{timer_random_delay}

                      [Install]
                      WantedBy=timers.target
                      HEREDOC
    end
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
