Gem::Specification.new do |spec|
  spec.name                   = "fbk"
  spec.version                = "1.0.0"
  spec.date                   = "2015-01-09"
  spec.summary                = "Interacts with some parts of the FB Graph API."
  spec.description            = "Interacts with some parts of the FB Graph API."
  spec.authors                = ["Pedro Gimenez"]
  spec.email                  = ["pedro@chicisimo.com"]
  spec.files                  = Dir["lib/**/*.rb"]
  spec.homepage               = "http://github.com/pedrogimenez/fbk"
  spec.extra_rdoc_files       = ["README.md"]
  spec.required_ruby_version  = ">= 2.1.0"
  spec.licenses               = ["MIT"]

  spec.add_runtime_dependency     "nestful"

  spec.add_development_dependency "rspec", "~> 3.0"
end
