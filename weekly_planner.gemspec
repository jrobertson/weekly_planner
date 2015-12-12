Gem::Specification.new do |s|
  s.name = 'weekly_planner'
  s.version = '0.3.2'
  s.summary = 'The weekly_planner gem primarily creates a weekly-planner.txt template file'
  s.authors = ['James Robertson']
  s.files = Dir['lib/weekly_planner.rb']
  s.add_runtime_dependency('dynarex', '~> 1.5', '>=1.5.44')
  s.signing_key = '../privatekeys/weekly_planner.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/weekly_planner'
end
