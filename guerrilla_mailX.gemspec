require_relative 'lib/guerrilla_mailX/version'

Gem::Specification.new do |spec|
  spec.name        = 'guerrilla_mailX'
  spec.version     = GuerrillaMailX::VERSION
  spec.date        = '2020-05-20'
  spec.authors     = ["Himanshu Gupta"]
  spec.email       = ["gupta.himanshu@thinkfuture.us"]

  spec.summary     = "Ruby gem to get mail from guerrillamail.com and verify sent mails"
  spec.description = "Ruby gem to get mail from guerrillamail.com. With this gem you can use guerrillamail 
                      APIs and verify subject and body of received emails."
  spec.homepage    = 'https://github.com/himanshu-thinkfuture/guerrilla_mailX'
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage



  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
  #   `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # end
  spec.files       = %w[guerrilla_mailX.gemspec CODE_OF_CONDUCT.md README.md LICENSE.txt] + Dir['lib/**/*.rb'] + Dir['bin/**/*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'pry' 

  spec.add_runtime_dependency 'rest-client', '>=2.1.0'
  spec.add_runtime_dependency 'activesupport', '~> 5.0', '>= 5.0.0.1'
  spec.add_runtime_dependency 'rainbow', '~> 2.1'


end