
module Aurita
module Console

  class Runner
    
    def initialize(argv)
      @argv = argv.flatten
      @project_name = argv[0]
      @module_name  = argv[1]

      if(!@project_name || !@module_name) then
        usage()
      end

      Aurita.load_project @project_name
      Aurita.bootstrap
    end

    def run
      require("aurita/console/console_modules/#{@module_name}")
      @module = Aurita::Console.const_get(@module_name.to_s.camelcase)
      @module.new(@argv[2..-1]).run
    end

    def usage
      puts <<EOS
Usage: 

    aurita <project name> <console module name> <module args>

EOS
    end

  end

end
end

