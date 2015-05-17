Gem::Specification.new do |s|
  s.name = 'logstash-output-pushover'
  s.version = "0.1.0"
  s.licenses = ["ISC"]
  s.summary = "Logstash output to Pushover."
  s.description = "This is a Logstash output for the Pushover push notification service."
  s.authors = ["Jasper Lievisse Adriaanse"]
  s.email = "j@jasper.la"
  s.homepage = "https://github.com/jasperla/logstash-output-pushover"
  s.require_paths = ["lib"]

  # Files
  s.files = `git ls-files`.split($\)
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "output" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core", ">= 1.4.0", "< 2.0.0"
  s.add_development_dependency "logstash-devutils"
end
