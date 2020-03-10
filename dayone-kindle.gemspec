require File.expand_path('../lib/dayone-kindle/version', __FILE__)

Gem::Specification.new do |s|
  s.authors       = ['Tim Petricola']
  s.email         = 'tim.petricola@gmail.com'
  s.summary       = 'Import highlights from Kindle to Day One'
  s.license       = 'MIT'
  s.homepage      = 'https://github.com/TimPetricola/dayone-kindle'
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files         = `git ls-files`.split "\n"
  s.test_files    = `git ls-files -- test/*`.split "\n"
  s.name          = 'dayone-kindle'
  s.require_paths = ['lib']
  s.version       = DayOneKindle::VERSION

  s.add_development_dependency 'rspec', '~> 3.3.0'
  s.add_development_dependency 'rake', '~> 13.0.1'
  s.add_runtime_dependency 'thor', '~> 0.19.1'
end
