Gem::Specification.new do |s|
  s.name        = 'easycomments'
  s.version     = '1.0.5'
  s.date        = '2015-04-24'
  s.required_ruby_version = '>= 2.0.0'
  s.summary     = "Simple and easy to use comment system"
  s.description = <<EOF
EasyComments(EC) is an easy to use comment system with a simple api
for posting and retrieving comments.It also comes bundled with a dashboard
for moderating your comments.
EOF

  s.files       = `git ls-files`.split("\n")
  s.executables << 'ec'

  s.authors = ["Zisis Maras"]
  s.email = 'zisismaras@gmail.com'
  s.homepage = 'https://github.com/zisismaras/easycomments'
  s.license = 'MIT'
end
