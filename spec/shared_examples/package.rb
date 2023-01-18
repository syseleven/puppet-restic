# frozen_string_literal: true

shared_examples 'package' do |params = {}|
  defaults = {
    'package_ensure' => 'present',
    'package_manage' => true,
    'package_name' => 'restic',
  }

  values = defaults.merge(params)

  if values['install_method'] == 'package'
    if values['package_manage']
      it {
        is_expected.to contain_package(values['package_name']).only_with(
          {
            'ensure' => values['package_ensure'],
          },
        )
      }
    else
      it {
        is_expected.not_to contain_package(values['package_name'])
      }
    end
  elsif values['install_method'] == 'url'
    it { is_expected.to contain_package('bzip2') }

    it { is_expected.to contain_archive("restic-#{values['package_version']}.bz2").with(source: "https://github.com/restic/restic/releases/download/v#{values['package_version']}/restic_#{values['package_version']}_linux_amd64.bz2") }

    it { is_expected.to contain_file("/usr/local/bin/restic-#{values['package_version']}").with(ensure: 'file', mode: '0555', owner: 'root', group: 'root') }

    it { is_expected.to contain_file('/usr/local/bin/restic').only_with(ensure: 'link', target: "/usr/local/bin/restic-#{values['package_version']}") }

    if values['checksum'] != :undef
      it { is_expected.to contain_archive("restic-#{values['package_version']}.bz2").with(checksum_type: 'sha256', checksum: values['checksum']) }
    end
  end
end
