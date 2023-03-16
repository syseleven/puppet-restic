# frozen_string_literal: true

require 'spec_helper'

describe 'restic' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      TESTS.each do |title, params|
        context "with #{title}" do
          parameter = DEFAULTS.merge(params)

          let(:params) do
            parameter
          end

          it {
            is_expected.to compile.with_all_deps
          }

          include_examples 'package', parameter

          params['repositories']&.each do |repository, config|
            include_examples 'repository', repository, config, parameter

            it {
              is_expected.to contain_class('restic::package').that_comes_before("Restic::Repository[#{repository}]")
            }
          end
        end
      end
    end
  end
end
