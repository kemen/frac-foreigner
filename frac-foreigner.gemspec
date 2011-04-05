# -*- encoding: utf-8 -*-
 
Gem::Specification.new do |s|
  s.name = 'frac-foreigner'
  s.version = '0.0.1'
  s.summary = 'Foreigner adapted to SQLServer and with (partial) natural pk support'
  s.description = ''

  s.required_ruby_version     = '>= 1.8.6'
  s.required_rubygems_version = '>= 1.3.5'

  s.author            = 'Cloned by Matthew Higgins'
  s.email             = ''
  s.homepage          = ''
  s.rubyforge_project = 'frac-foreigner'

  s.extra_rdoc_files = ['README.rdoc']
  s.files = %w(MIT-LICENSE Rakefile README.rdoc) + Dir['lib/**/*.rb'] + Dir['test/**/*.rb']
  s.require_paths = %w(lib)  
end
