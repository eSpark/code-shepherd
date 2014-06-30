lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elodin/version'

Gem::Specification.new do |spec|
  spec.name          = "elodin"
  spec.version       = Elodin::VERSION
  spec.authors       = ["Alex Koppel"]
  spec.email         = ["koppel@esparklearning.com"]
  spec.description   = %q{A fine Arcanist replacement}
  spec.summary       = %q{A Github tool that provides arcanist/Phabricator-like framing for Github pull requests.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "thor"
end
