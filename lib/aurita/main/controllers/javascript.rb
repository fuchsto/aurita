
require('aurita/controller')
# Aurita::Main.import_model :model_register

module Aurita
module Main
  
  class Javascript_Controller < App_Controller

    def render_js_file(file_path)
      puts "/* ==============================================\n   === FILE: #{file_path} \n   ==============================================*/"
      render_file(file_path)
      puts "/* ==============================================\n   === END FILE: #{file_path} \n   ==============================================*/"
    end

    def include_all
      render_js_file('public/inc/log.js')
      
      render_js_file('public/inc/lightboxEx/js/lightboxEx.js')

      render_js_file('public/inc/ui.js')
      render_js_file('public/inc/helpers.js')
      render_js_file('public/inc/cookie.js')

      render_js_file('public/inc/init.js')
      render_js_file('public/inc/remote_call.js')
      render_js_file('public/inc/cuba_async.js')
      render_js_file('public/inc/feedback.js')
      render_js_file('public/inc/iframe.js')
      render_js_file('public/inc/asset_management.js')
      render_js_file('public/inc/login.js')
      render_js_file('public/inc/backbutton.js')
      render_js_file('public/inc/box.js')
      render_js_file('public/inc/poll.js')

      render_js_file('public/inc/jscalendar/calendar.js')
      render_js_file('public/inc/jscalendar/lang/calendar-de.js')
      render_js_file('public/inc/jscalendar/calendar-setup.js')

      render_js_file('public/inc/md5.js')

      render_js_file('public/inc/setup.js')

    end

  end

end
end
