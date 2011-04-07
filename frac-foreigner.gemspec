# -*- encoding: utf-8 -*-
 
Gem::Specification.new do |s|
  s.name = 'frac-foreigner'
  s.version = '0.0.4'
  s.summary = 'Foreigner adapted to SQLServer and with natural primary key support for schema dumper and migrations'
  s.description = 'Foreigner adapted to SQLServer and with natural primary key support for schema dumper and migrations'

  s.required_ruby_version     = '>= 1.8.6'
  s.required_rubygems_version = '>= 1.3.5'

  s.author            = 'Cloned from Matthew Higgins\' Foreigner gem'
  s.email             = ''
  s.homepage          = 'http://www.kemen.it'
  s.rubyforge_project = 'frac-foreigner'

  s.extra_rdoc_files = ['README.rdoc']
  s.files = %w(MIT-LICENSE Rakefile README.rdoc) + Dir['lib/**/*.rb'] + Dir['test/**/*.rb']
  s.require_paths = %w(lib)  
end
