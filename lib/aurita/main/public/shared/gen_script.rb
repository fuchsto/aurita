
$scripts = [ 
  'jscalendar/calendar', 
  'jscalendar/lang/calendar-de', 
  'jscalendar/calendar-setup', 
  :log, 
  :helpers, 
  :cookie, 
  :xhconn, 
  :md5, 
  :aurita, 
  :error, 
  :backbutton, 
  :message_box, 
  :context_menu, 
  :aurita_gui, 
  :editor, 
  :login, 
  :main, 

# Plugins

  :wiki, 
  :poll, 
  :messaging, 
  :bookmark, 
  :publish, 

# Finally
  :onload
]

File.open("./aurita_bundle.js", "w") { |out|
  $scripts.each do |script_filename|
  File.open("./script/#{script_filename}.js", "r") { |f|
    out.write("\n///////////////////////////////////////////////////////")
    out.write("\n// BEGIN #{script_filename}")
    out.write("\n///////////////////////////////////////////////////////\n")
    out.write(f.read)
    out.write("\n///////////////////////////////////////////////////////")
    out.write("\n// END #{script_filename}")
    out.write("\n///////////////////////////////////////////////////////\n")
  }
  end
}

