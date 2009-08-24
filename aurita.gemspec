
require 'rake'

spec = Gem::Specification.new { |s|

  s.name = 'aurita' 
  s.rubyforge_project = 'aurita'
  s.summary = 'Aurita is a resource- and plugin-based application 
               framework that simplifies realization of rich internet applications. '
  s.description = <<-EOF
    Aurita is a resource- and plugin-based application framework that simplifies 
    realization of rich internet applications. An aurita application can be 
    everything from a todo list up to a distributed community portal.
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
