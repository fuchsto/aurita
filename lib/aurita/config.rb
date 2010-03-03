
require('aurita/base/configuration')

module Aurita

  class App_Configuration < Simple_Configuration

    admin_emails [ 'root@localhost' ]

    app_base_path '/usr/share/gitwc/'
    base_path '/usr/share/gitwc/aurita/lib/aurita/'
    projects_base_path '/usr/share/gitwc/aurita_projects/'
    plugins_path  '/usr/share/gitwc/aurita-plugins/'

    sys_log_path '/var/log/aurita/sys.log'
    run_log_path '/var/log/aurita/sys.log'

  end

end

