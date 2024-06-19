# frozen_string_literal: true

shared_examples 'repository' do |title, config, params|
  values = params.merge(config)

  if values['enable_backup'] && values['backup_path'].nil?
    it {
      is_expected.to compile.and_raise_error(%r{restic::repository[#{title}]: You have to set \$backup_path if you enable the backup!})
    }
  end

  if values['enable_restore'] && values['restore_path'].nil?
    it {
      is_expected.to compile.and_raise_error(%r{restic::repository[#{title}]: You have to set \$enable_restore if you enable the restore!})
    }
  end

  type = values['type']
  host = values['host']
  bucket = values['bucket']
  gcs_repository = values['gcs_repository']

  success_exit_status = values['backup_exit3_success'] ? 3 : :undef
  repository = case type
               when 'gs'
                 "#{type}:#{bucket}:/#{gcs_repository}"
               else
                 bucket == :undef ? "#{type}:#{host}" : "#{type}:#{host}/#{bucket}"
               end
  config_file = "/etc/default/restic_#{title}"
  type_config = case values['type']
                when 's3'
                  {
                    'AWS_ACCESS_KEY_ID' => values['id'],
                    'AWS_SECRET_ACCESS_KEY' => values['key'],
                    'RESTIC_PASSWORD' => values['password'],
                    'RESTIC_REPOSITORY' => repository,
                  }
                when 'gs'
                  {
                    'GOOGLE_PROJECT_ID' => values['gcs_project_id'],
                    'GOOGLE_APPLICATION_CREDENTIALS' => values['gcs_credentials_path'],
                    'RESTIC_PASSWORD' => values['password'],
                    'RESTIC_REPOSITORY' => repository,
                  }
                else
                  {
                    'RESTIC_PASSWORD' => values['password'],
                    'RESTIC_REPOSITORY' => repository,
                  }
                end

  if values['init_repo']
    it {
      is_expected.to contain_exec("restic_init_#{title}").only_with(
        {
          'command' => "#{values['binary']} init",
          'environment' => type_config.reduce([]) { |memo, (key, value)| memo << "#{key}=#{value}" }.sort,
          'onlyif' => "#{values['binary']} snapshots 2>&1 | grep -q 'Is there a repository at the following location'",
        },
      )
    }
  else
    it {
      is_expected.not_to contain_exec("restic_init_#{title}")
    }
  end

  if values['enable_backup'] || values['enable_forget'] || values['enable_restore']
    it {
      is_expected.to contain_concat(config_file).with(
        {
          'ensure'         => 'present',
          'ensure_newline' => true,
          'group'          => 'root',
          'mode'           => '0440',
          'owner'          => 'root',
          'show_diff'      => true,
        },
      )
    }

    config_keys = {
      'GLOBAL_FLAGS' => [ values['global_flags'] ].flatten.join(' '),
      'GOMAXPROCS'   => values['max_cpus']
    }.merge(type_config).merge(type_config)

    config_keys.each do |key, data|
      if data != :undef
        it {
          is_expected.to contain_concat__fragment("restic_fragment_#{title}_#{key}").with(
            {
              'content' => sensitive("#{key}='#{data}'"),
              'target'  => config_file,
            },
          )
        }
      end
    end
  else
    it {
      is_expected.to contain_concat(config_file).with(
        {
          'ensure' => 'absent',
        },
      )
    }
  end

  ##
  ## backup service
  ##
  backup_commands = [
    values['backup_pre_cmd'],
    "#{values['binary']} backup \$GLOBAL_FLAGS \$BACKUP_FLAGS",
    values['backup_post_cmd'],
  ]

  backup_config = [ values['backup_flags'], values['backup_path'] ].flatten
  backup_config.delete(:undef)

  backup_keys = {
    'BACKUP_FLAGS' => backup_config.join(' '),
  }

  include_examples 'service', "restic_backup_#{title}", backup_commands, config_file, backup_keys, values['enable_backup'], values['group'], values['user'], values['backup_timer'], success_exit_status

  ##
  ## forget service
  ##
  forget_commands = [
    values['forget_pre_cmd'],
    "#{values['binary']} forget \$GLOBAL_FLAGS \$FORGET_FLAGS",
    values['forget_post_cmd'],
  ]

  forgets = values['forget'].map { |k, v| "--#{k} #{v}" }

  prune = if values['prune']
            '--prune'
          else
            nil
          end

  forget_config = [ forgets, prune, values['forget_flags'] ].flatten
  forget_config.delete(:undef)
  forget_config.delete(nil)

  forget_keys = {
    'FORGET_FLAGS' => forget_config.join(' '),
  }

  include_examples 'service', "restic_forget_#{title}", forget_commands, config_file, forget_keys, values['enable_forget'], values['group'], values['user'], values['forget_timer']

  ##
  ## restore service
  ##
  restore_commands = [
    values['restore_pre_cmd'],
    "#{values['binary']} restore \$GLOBAL_FLAGS \$RESTORE_FLAGS",
    values['restore_post_cmd'],
  ]

  restore_path = if values['restore_path'] == :undef
                   ''
                 else
                   values['restore_path']
                 end

  restore_config = [ "-t #{restore_path}", values['restore_flags'], values['restore_snapshot'] ].flatten
  restore_config.delete(:undef)
  restore_config.delete(nil)

  restore_keys = {
    'RESTORE_FLAGS' => restore_config.join(' '),
  }

  include_examples 'service', "restic_restore_#{title}", restore_commands, config_file, restore_keys, values['enable_restore'], values['group'], values['user'], values['restore_timer']
end
