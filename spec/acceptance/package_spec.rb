require 'spec_helper_acceptance'

describe 'restic' do
  describe 'using packages' do
    it_behaves_like 'the example', 's3.pp'
  end
end
