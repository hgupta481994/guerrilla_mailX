Gem::Specification.new do |spec|
  spec.name        = 'guerrilla_mailX'
  spec.version     = '0.0.9'
  spec.date        = '2020-05-20'
  spec.summary     = "Ruby gem to get mail from guerrillamail.com and verify sent mails"
  spec.description = "Ruby gem to get mail from guerrillamail.com. With this gem you can use guerrillamail 
                      APIs and verify subject and body of email received."
  spec.authors     = ["Himanshu Gupta"]
  spec.email       = 'gupta.himanshu@thinkfuture.us'
  spec.files       = %w[guerrillamailchecker.gemspec] + Dir['lib/**/*.rb']
  spec.homepage    = 'https://github.com/himanshu-thinkfuture/guerrillamail-checker'

  spec.require_paths = ['lib']
  

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake', '>= 10.0'
  # spec.add_development_dependency 'rspec', '>= 3.9.0'
  spec.add_development_dependency 'pry' 

  spec.add_runtime_dependency 'rest-client', '>=2.1.0'
  spec.add_runtime_dependency 'activesupport', '~> 5.0', '>= 5.0.0.1'
  spec.add_runtime_dependency 'rainbow', '~> 2.1'


end