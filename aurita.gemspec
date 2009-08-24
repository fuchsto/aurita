
require 'rake'

spec = Gem::Specification.new { |s|

  s.name = 'aurita' 
  s.rubyforge_project = 'aurita'
  s.summary = 'Dead-simple object-oriented creation of HTML elements, including forms, tables and many more. '
  s.description = <<-EOF
Aurita::GUI provides an intuitive and flexible API for object-oriented creation 
of primitive and complex HTML elements, such as tables and forms. 
It is a core module of the Aurita application framework, but it can be used 
as stand-alone library in any context (such as rails). 
As there seems to be a lack of ruby form generators, i decided to release this 
part of Aurita in a single gem with no dependencies on aurita itself. 
  EOF
  s.version = '0.7.0'
  s.author  = 'Tobias Fuchs'
  s.email   = 'twh.fuchst@gmail.com'
  s.date    = Time.now
  s.files   = '*.rb'

  s.add_dependency('lore', '>= 0.4.0')
  s.add_dependency('aurita-gui', '>= 0.4.0')
  s.add_dependency('prawn', '>= 0.4.0')
  s.add_dependency('htmlentities', '>= 0.4.1')
  s.add_dependency('mongrel', '>= 1.1.5')
  s.add_dependency('rack', '>= 1.0.0')
  s.add_dependency('wirble', '>= 0.1.3')

  s.files = FileList['*', 
                     'lib/*', 
                     'lib/aurita/*', 
                     'lib/aurita/form/*', 
                     'bin/*', 
                     'spec/*'].to_a

  s.has_rdoc = true
  s.rdoc_options << '--title' << 'Aurita' <<
                    '--main' << 'README.rb' <<
                    '--line-numbers'

  s.homepage = 'http://intra.wortundform.de/doc/'

}
