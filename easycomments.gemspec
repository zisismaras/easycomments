Gem::Specification.new do |s|
  s.name        = 'easycomments'
  s.version     = '1.0.0'
  s.date        = '2015-03-30'
  s.summary     = "Simple and easy to use comment system"
  s.description = <<EOF
EasyComments(EC) is an easy to use comment system with a simple api
for posting and retrieving comments.It also comes bundled with a dashboard
for moderating your comments.
EOF

  s.files       = `git ls-files`.split("\n")
  s.executables << 'ec'

  s.add_development_dependency 'airborne', '~> 0.1', '>=0.1.15'
  s.add_development_dependency "rake", '~> 10.4', '>= 10.4.2'

  s.authors = ["Zisis Maras"]
  s.email = 'zisismaras@gmail.com'
  s.homepage = 'http://rubygems.org/gems/hola'
  s.license = 'MIT'
end