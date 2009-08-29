
# Tell Lore how to access the project's main database: 
Lore.add_login_data 'aurita' => [ 'cuba', 'cuba23' ]

module Aurita

  class Project_Configuration 

    # Name of this project. 
    def self.project_name
      'tutorial'
    end

    # Name of this project's main database. 
    def self.context
      'aurita'
    end

    # For sessions etc. 
    def self.domain
      'http://intra.wortundform.de'
    end

    # For base path of links
    def self.remote_path
      'http://intra.wortundform.de/aurita/'
    end

    # File system path to this project. 
    def self.base_path
      "#{Aurita::Configuration.projects_base_path}#{project_name}/"
    end
    def self.project_title
      'aurita tutorial'
    end

    # What theme to use in a session (by name). 
    # Could be a fixed string or some routine resolving the 
    # theme name. 
    def self.default_theme
      Aurita.user.profile.theme
    end

  end

end

