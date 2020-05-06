Gem::Specification.new do |s|
  s.name        = 'guerrillamailchecker'
  s.version     = '0.0.1'
  s.date        = '2020-04-30'
  s.summary     = "Ruby gem to get mail from guerrillamail.com"
  s.description = "Ruby gem to get mail from guerrillamail.com"
  s.authors     = ["Himanshu Gupta"]
  s.email       = 'gupta.himanshu@thinkfuture.us'
  s.files       = %w[guerrillamailchecker.gemspec] + Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/himanshu-thinkfuture/guerrillamail-checker'

  s.require_paths = ['lib']

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rest-client', '~>2.1.0'
  s.add_development_dependency 'rspec', '~> 3.0'
end