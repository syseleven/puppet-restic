# frozen_string_literal: true

shared_examples 'package' do |params = {}|
  defaults = {
    'package_ensure' => 'present',
    'package_manage' => true,
    'package_name' => 'restic',
  }

  values = defaults.merge(params)

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
end
