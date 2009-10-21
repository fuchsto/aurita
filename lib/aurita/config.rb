
# This is an example configuration for Aurita in development or testing mode. 

module Aurita

  class Configuration

    $KCODE = 'UTF-8'
    @@app_base_path      = '/usr/share/gitwc/'
    @@admin_emails       = [ 'root@localhost' ]
    @@base_path          = @@app_base_path + 'aurita/lib/aurita/'
    @@projects_base_path = @@app_base_path + 'aurita_projects/'
    @@plugins_path       = @@app_base_path + 'aurita-plugins/'

    @@sys_log_path = '/var/log/aurita/sys.log'
    @@run_log_path = '/var/log/aurita/sys.log'

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
  end

end

