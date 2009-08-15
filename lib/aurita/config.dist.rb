
module Aurita

  class Configuration

    $KCODE = 'UTF-8'
    @@app_base_path      = '/usr/share/'
    @@admin_emails       = [ 'root@localhost' ]
    @@base_path          = @@app_base_path + 'aurita/'
    @@projects_base_path = @@app_base_path + 'aurita_projects/'
    @@plugins_path       = @@app_base_path + 'aurita_plugins/'
    @@run_log_path       = '/var/log/aurita/run.log' 
    @@sys_log_path       = '/var/log/aurita/sys.log' 
# You can use any IO instance for log outputs, like: 
#   @@run_log_path       = STDERR
    Lore.add_login_data(
    'project_db_1' => [ 'user', 'pass' ], 
    'project_db_2' => [ 'user', 'pass' ]
    )

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

  end

end

