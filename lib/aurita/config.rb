
require('aurita/base/configuration')

module Aurita

  class App_Configuration < Simple_Configuration

    admin_emails [ 'root@localhost' ]

    app_base_path '/usr/share/gitwc/'
    base_path '/usr/share/gitwc/aurita/lib/aurita/'
    projects_base_path '/usr/share/gitwc/aurita_projects/'
    plugins_path  '/usr/share/gitwc/aurita-plugins/'

    sys_log(:production => '/usr/share/gitwc/log/aurita/sys.log', 
            :debug      => STDERR) 
    run_log(:production => '/usr/share/gitwc/log/aurita/sys.log', 
            :debug      => STDERR) 

    def self.sys_log_path
      sys_log[Aurita.runmode] || STDERR
    end
    def self.run_log_path
      run_log[Aurita.runmode] || STDERR
    end

  end

end

