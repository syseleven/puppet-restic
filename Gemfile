source ENV['GEM_SOURCE'] || 'https://rubygems.org'

def location_for(place_or_version, fake_version = nil)
  git_url_regex = %r{\A(?<url>(https?|git)[:@][^#]*)(#(?<branch>.*))?}
  file_url_regex = %r{\Afile:\/\/(?<path>.*)}

  if place_or_version && (git_url = place_or_version.match(git_url_regex))
    [fake_version, { git: git_url[:url], branch: git_url[:branch], require: false }].compact
  elsif place_or_version && (file_url = place_or_version.match(file_url_regex))
    ['>= 0', { path: File.expand_path(file_url[:path]), require: false }]
  else
    [place_or_version, { require: false }]
  end
end

ruby_version_segments = Gem::Version.new(RUBY_VERSION.dup).segments
minor_version = ruby_version_segments[0..1].join('.')

group :development do
  gem "json", '= 2.0.4',                                         require: false if Gem::Requirement.create('~> 2.4.2').satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "json", '= 2.1.0',                                         require: false if Gem::Requirement.create(['>= 2.5.0', '< 2.7.0']).satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "json", '= 2.3.0',                                         require: false if Gem::Requirement.create(['>= 2.7.0', '< 2.8.0']).satisfied_by?(Gem::Version.new(RUBY_VERSION.dup))
  gem "puppet-module-posix-default-r#{minor_version}", '~> 1.0', require: false, platforms: [:ruby]
  gem "puppet-module-posix-dev-r#{minor_version}", '~> 1.0',     require: false, platforms: [:ruby]
end

group :system_tests do
  gem "puppet-module-posix-system-r#{minor_version}", '~> 1.0', require: false, platforms: [:ruby]
end

puppet_version = ENV['PUPPET_GEM_VERSION']
facter_version = ENV['FACTER_GEM_VERSION']
hiera_version = ENV['HIERA_GEM_VERSION']

gems = {}

gems['puppet'] = location_for(puppet_version)

# If facter or hiera versions have been specified via the environment
# variables

gems['facter'] = location_for(facter_version) if facter_version
gems['hiera'] = location_for(hiera_version) if hiera_version

gems.each do |gem_name, gem_params|
  gem gem_name, *gem_params
end

gem 'metadata-json-lint'
gem 'puppet-lint'
gem 'puppet-lint-absolute_classname-check'
gem 'puppet-lint-absolute_template_path'
gem 'puppet-lint-alias-check'
gem 'puppet-lint-anchor-check'
gem 'puppet-lint-duplicate_class_parameters-check'
gem 'puppet-lint-empty_lines_around_body-check'
gem 'puppet-lint-legacy_facts-check'
gem 'puppet-lint-manifest_whitespace-check'
gem 'puppet-lint-no_file_path_attribute-check'
gem 'puppet-lint-no_symbolic_file_modes-check'
gem 'puppet-lint-package_ensure-check'
gem 'puppet-lint-param-docs'
gem 'puppet-lint-resource_reference_syntax'
gem 'puppet-lint-strict_indent-check'
gem 'puppet-lint-top_scope_facts-check'
gem 'puppet-lint-topscope-variable-check'
gem 'puppet-lint-trailing_comma-check'
gem 'puppet-lint-trailing_newline-check'
gem 'puppet-lint-uncuddled_else-check'
gem 'puppet-lint-unquoted_string-check'
gem 'puppet-lint-variable_contains_upcase'
gem 'puppet-lint-version_comparison-check'
gem 'puppet-syntax'
gem 'ra10ke'
gem 'rubocop'
gem 'rubocop-performance'
gem 'rubocop-rspec'

# Evaluate Gemfile.local and ~/.gemfile if they exist
extra_gemfiles = [
  "#{__FILE__}.local",
  File.join(Dir.home, '.gemfile'),
]

extra_gemfiles.each do |gemfile|
  if File.file?(gemfile) && File.readable?(gemfile)
    eval(File.read(gemfile), binding)
  end
end
# vim: syntax=ruby
