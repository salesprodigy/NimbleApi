# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nimble/version'

Gem::Specification.new do |spec|

  spec.name             = "nimble-api"
  spec.version          = NimbleApi::VERSION
  spec.homepage         = "https://github.com/aptos/NimbleApi"
  spec.platform         = Gem::Platform::RUBY
  spec.license          = 'Apache'

  spec.summary          = "Nimble CRM Api Wrapper"
  spec.description      = "Ruby wrapper for the Nimble CRM Api."

  spec.authors          = ["Brian Wilkerson"]
  spec.email            = "brian@taskit.io"

  spec.files         = ["Gemfile", "Gemfile.lock", "README.md", "Rakefile", "lib/nimble-api.rb", "lib/nimble/base.rb", "lib/nimble/contact.rb", "lib/nimble/contacts.rb", "lib/nimble/metadata.rb", "lib/nimble/version.rb", "nimble_api.gemspec", "spec/integration/contact_spec.rb", "spec/integration/contacts_spec.rb", "spec/integration/metadata_spec.rb", "spec/spec_helper.rb", "spec/unit/base_spec.rb"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "pry"

  spec.add_dependency "faraday", "~> 0.8"
  spec.add_dependency "chronic", "~> 0.10"
  spec.add_dependency "json", "~> 1.7"

end