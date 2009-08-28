
require 'aurita'
Aurita.load_project :maecki
Aurita::Main.import_model :hierarchy
Aurita::Main.import_model :hierarchy_entry
Aurita.import_plugin_model :wiki, :article

require 'rubygems'

include Aurita::Plugins::Wiki

# schema_fix = "ALTER TABLE hierarchy_entry rename type to entry_type; 
#              ALTER TABLE hierarchy_entry add content_id integer; "
# Lore::Connection.perform(schema_fix)

Hierarchy_Entry.all_with(Hierarchy_Entry.entry_type == 'ARTICLE').each { |entry|
  article_id = entry.interface.gsub('Wiki::Article/show/article_id=','')
  puts article_id
  article = Article.load(:article_id => article_id)
  if article then
  puts article.content_id
    entry.content_id = article.content_id
    entry.commit
  else 
    puts 'Article not found: ' << article_id.to_s
  end
}

