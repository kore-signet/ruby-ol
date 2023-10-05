# frozen_string_literal: true

require_relative "lib/openlibrary/version"

Gem::Specification.new do |spec|
  spec.name = "openlibrary"
  spec.version = OpenLibrary::VERSION
  spec.authors = ["kore"]
  spec.email = ["kore@cat-girl.gay"]

  spec.summary = "a Ruby OpenLibrary client"
  spec.homepage = "https://github.com/kore-signet/ruby-ol"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kore-signet/ruby-ol"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("dry-types")
  spec.add_dependency("dry-struct")
  spec.add_dependency("dry-validation")
  spec.add_dependency("faraday")
  spec.add_dependency("faraday-follow_redirects")
  spec.add_dependency("faraday-http-cache")

end
