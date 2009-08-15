
# = Welcome to Aurita
#
# This is the API documentation for Aurita's core implementation. 
#
# In total, there are the following API documentations: 
#
# [*Core*] Aurita's core (this API): http://intra.wortundform.de/doc/aurita/
# [*Main*] Aurita's core application logic API: http://intra.wortundform.de/doc/aurita-main/
# [*GUI*] Object-oriented GUI API: http://intra.wortundform.de/doc/aurita-gui/
# [*Plugins*] Aurita's vendor plugins: http://intra.wortundform.de/doc/aurita-plugins/
# [*Lore*] Aurita's ORM: http://intra.wortundform.de/doc/lore/
#
# [*All*] All APIs in one (big!): http://intra.wortundform.de/doc/all
# 
# ----
#
# A typical Aurita application consists of the following layers: 
#
#
# 1. Web server (lighttpd, mongrel, webrick, ...)
# 2. Middleware (rack or custom handler) 
# 3. Dispatcher 
# 4. Model / View / Controller 
#
# Aurita itself implements layers 2, 3 and 4. 
# As middleware, it also offers custom FCGI handler as interface 
# to the web server, which is used by default. A Rack implementation 
# is on its way. 
# 
# == Controllers
#
# The most interesting part. Controllers implement pure business 
# logic and client / server interaction. 
# Controllers use models to retreive and modify data, and views to 
# display them. 
#
# See 
# - Aurita::Base_Controller
# - Aurita::Base_Controller_Methods
#
# == Models 
#
# Lore ORM is used for defining and working with models and DB 
# abstraction. 
# Aurita extends Lore::Model by several behaviours, like 
# Categorized_Behaviour and Taggable_Behaviour. 
#
# See Aurita::Model
#
# == Views 
#
# There are two ways how user interfaces can be generated: 
# Templates and GUI elements. 
# 
# Templates are the a well-known standard: Write an interface 
# skeleton with close to no intelligence, fill in values, and 
# print it. Templates are ERB files residing in folders named 
# 'views' (in Aurita itself, in plugins, or in the project). 
#
# Aurita also offers GUI elements, which are real Ruby objects, 
# This concept is comparable to e.g. Qt: Define a class derived 
# from Aurita::GUI::Element or Aurita::GUI::Widget, create instances 
# of it, and render them at the very end. 
# This way, a GUI element class can be derived from an existing 
# one. 
#
# The advantage of GUI objects over templates is flexibility and 
# reuse of interface logic - ever tried to reuse an HTML template 
# but with slight changes? This is where they come to play. 
#
# In general, both are necessary. Use templates for interface 
# parts that do not offer complex functionality but are quickly 
# written in HTML. 
# However, you should consider using a GUI object for a table 
# that is sortable by columns, for instance. 
#
# A controller that responds with an interface may either render 
# a template or return an Aurita::GUI::Element instance. 
# 
# See documentation on Aurita::GUI  
# - Aurita::View_Helpers
# - Aurita::GUI::Element
# - Aurita::GUI::HTML
# - Aurita::GUI::Widget
# 
# ----
#
# == Plugins
#
# Aurita is a plugin-based application framework. That is to say, 
# it offers basic application logic that is supposed to be useful 
# in all applications based on it, but without plugins, it would 
# just be a blank page. 
#
# Aurita::Main - which includes core models / views / controllers - 
# is treated as a plugin, too, but it is loaded automatically in 
# every Aurita project. 
#
# Aurita::Main also includes lots of GUI modules. Context menus, 
# tables and much more can be used easily for every business object 
# right away, for instance.
#
# By using Aurita::Main and adding existing plugins, you can write 
# your own application without having to reinvent tagging, user 
# management, versioning, digital asset management, form generation 
# ... for every project. 
#
# If your project needs a wiki, add the Wiki plugin. If you need 
# todo lists, add the Todo plugin, and so on. Plugins do not have 
# to be stand-alone: The Todo plugin can hook into the Wiki plugin 
# so todo lists can be added to an article. 
# Of course it's possible to just use parts of a plugin's functions. 
# 
# See documentation on Aurita::Plugins
# - Aurita::Plugin::Manifest
# - Aurita::Plugin_Register
#
# == License
#
# Aurita has been developed by Tobias Fuchs and released under the 
# liberal MIT licence (See LICENSE file in your distribution). 
# 
#
