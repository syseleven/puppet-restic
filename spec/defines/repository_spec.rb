require 'spec_helper'

describe 'restic::repository' do
  on_supported_os.each do |os, facts|
    TESTS.each do |test|
      next unless test[1].has_key?('repositories')

      test[1]['repositories'].each do |title, values|
        context "on #{os}" do
          let(:facts) { facts }
          let(:title) { title }
          let(:params) { values }

          include_examples 'repository', title, values, DEFAULTS
        end
      end
    end
  end
end
