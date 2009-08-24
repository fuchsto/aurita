
# This is an example configuration for Aurita in development or testing mode. 

module Aurita

  class Configuration

    $KCODE = 'UTF-8'
    @@app_base_path      = '/usr/share/gitwc/'
    @@admin_emails       = [ 'root@localhost' ]
    @@base_path          = @@app_base_path + 'aurita/lib/aurita/'
    @@projects_base_path = @@app_base_path + 'aurita_projects/'
    @@plugins_path       = @@app_base_path + 'aurita_plugins/'

    @@sys_log_path = false
    @@run_log_path = false

    def self.base_path
      @@base_path
    end
    def self.app_base_path
      @@app_base_path
    end
    def self.admin_emails
      @@admin_emails
    end
    def self.projects_base_path
      @@projects_base_path
    end
    def self.plugins_path
      @@plugins_path
    end
    def self.run_log_path
      @@run_log_path
    end
    def self.sys_log_path
      @@sys_log_path
    end
    def self.run_log_path=(file)
      @@run_log_path = file
    end
    def self.sys_log_path=(file)
      @@sys_log_path = file
    end

  end

end

