
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mzr/api/error/version"

Gem::Specification.new do |spec|
  spec.name          = "mzr-api-error"
  spec.version       = Mzr::Api::Error::VERSION
  spec.authors       = ["micahbowie-pu"]
  spec.email         = ["mbowie@meazurelearning.com"]

  spec.summary       = "Render a structured and dynamic JSON response body to client applications."
  spec.description   = "Creates a base class that other errors can be inherit from to make error rendering easier errors uniform and easy"
  spec.homepage      = "https://www.meazurelearning.com"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "activesupport"
end
