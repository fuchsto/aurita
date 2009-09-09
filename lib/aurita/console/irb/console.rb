
require 'aurita'
Aurita.import 'console/console_runner'

begin
  require 'rubygems'
  require 'wirble'
  Wirble.init
  Wirble.colorize
rescue ::Exception => e
end

module Aurita
module Console

  class Console_Args

    @@project = 'default'

    def self.project
      @@project
    end

    def self.project=(project_name)
      @@project = project_name
    end

  end

  class Module_Proxy
    def method_missing(meth, *args)
      args = [Aurita::Console::Console_Args.project, meth] + args
      Aurita::Console::Runner.new(args).run
    end
  end

end
end

include Aurita
include Aurita::Console
include Aurita::Main
include Aurita::Plugins

Aurita::Console::Console_Args.project = ARGV[0]

def load_project(project_name)
  Aurita::Console::Console_Args.project = project_name
  Aurita.load_project project_name
end

def bootstrap
  Aurita.bootstrap
end

def disable_logging
  Lore.disable_logging
  Aurita::Configuration.run_log_path = false
  Aurita::Configuration.sys_log_path = false
end
alias disable_log disable_logging

def enable_logging
  Lore.enable_logging
  Lore.enable_query_log
  Lore.logfile = STDERR
  Lore.query_logfile = STDERR
  Aurita::Configuration.run_log_path = STDERR
  Aurita::Configuration.sys_log_path = STDERR
end

def set_user_id(uid)
  Aurita.session.user = User_Group.load(:user_group_id => uid)
end

def commands
  puts '>> Commands: '
  puts '>>   commands                            - show this screen'
  puts '>>   load_project <project name>         - Activate a project'
  puts '>>   set_user_id <user id>               - Set aurita user to mock'
  puts '>>   list_modules                        - List available console modules'
  puts '>>   aurita.<module name> <module args>  - Call a console module'
  puts '>> '
end

def list_modules
  rio(Aurita.base_path + 'bin/console_modules').each { |file|
    puts ">>   " << file.to_s.split('/').last.gsub('.rb','') if file.to_s[-3..-1] == '.rb'
  }
  return
end

def aurita(*args)
  if !Aurita.project then
    puts '>> No project loaded. '
    return
  end
  return Aurita::Console::Module_Proxy.new
end


puts '>> Aurita console running. '
commands()

