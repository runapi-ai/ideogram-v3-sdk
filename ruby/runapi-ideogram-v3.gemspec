# frozen_string_literal: true

Dir.chdir(__dir__) do

  Gem::Specification.new do |spec|
    spec.name = "runapi-ideogram-v3"
    spec.version = "0.2.7"
    spec.authors = ["RunAPI"]
    spec.email = ["contact@runapi.ai"]

    spec.summary = "Ideogram API Ruby SDK for RunAPI"
    spec.description = "The ideogram api Ruby SDK is the language-specific package for Ideogram V3 on RunAPI. Use this ideogram api package for text-to-image, character reference generation, edit, remix, reframe, and creative production flows when your application needs JSON request bodies, task status lookup, and consistent RunAPI errors in Ruby."
    spec.homepage = "https://runapi.ai/models/ideogram-v3"
    spec.license = "Apache-2.0"
    spec.required_ruby_version = ">= 3.1.0"
    spec.metadata["homepage_uri"] = "https://runapi.ai/models/ideogram-v3"
    spec.metadata["documentation_uri"] = "https://github.com/runapi-ai/ideogram-v3-sdk/blob/main/ruby/README.md"
    spec.metadata["source_code_uri"] = "https://github.com/runapi-ai/ideogram-v3-sdk"
    spec.metadata["changelog_uri"] = "https://github.com/runapi-ai/ideogram-v3-sdk/blob/main/CHANGELOG.md"



    spec.files = Dir.glob("lib/**/*") + %w[LICENSE README.md]
    spec.extra_rdoc_files = ["README.md"]
        spec.require_paths = ["lib"]

    spec.add_dependency "runapi-core", "~> 0.2.6"
  end
end
