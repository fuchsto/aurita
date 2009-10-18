
require 'rake'

spec = Gem::Specification.new { |s|

  s.name = 'aurita' 
  s.rubyforge_project = 'aurita'
  s.summary = 'Aurita is a resource- and plugin-based application framework for rich internet applications. '
  s.description = <<-EOF
    Aurita is a resource- and plugin-based application framework that simplifies 
    realization of rich internet applications. An aurita application can be 
    everything from a todo list up to a distributed community portal.
  EOF
  s.version = '0.7.0'
  s.author  = 'Tobias Fuchs'
  s.email   = 'twh.fuchst@gmail.com'
  s.date    = Time.now

  s.add_dependency('lore',         '>= 0.3.8')
  s.add_dependency('aurita-gui',   '>= 0.4.0')
  s.add_dependency('htmlentities', '>= 0.4.1')
  s.add_dependency('mongrel',      '>= 1.1.5')
  s.add_dependency('thin',         '>= 0.1.0')
  s.add_dependency('rack',         '>= 1.0.0')
  s.add_dependency('wirble',       '>= 0.1.3')
  s.add_dependency('configatron',  '>= 0.1.0')

  s.files = [
    'examples/project_example/plugins/main.rb',
    'examples/project_example/plugins/wiki.rb',
    'examples/project_example/config.rb',
    'lib/aurita.rb',
    'lib/aurita/config.dist.rb',
    'lib/aurita/handler/mongrel_daemon.rb',
    'lib/aurita/handler/thin_daemon.rb',
    'lib/aurita/handler/dispatcher.rb',
    'lib/aurita/handler/aurita_application.rb',
    'lib/aurita/handler/mongrel_handler.rb',
    'lib/aurita/base/attributes.rb',
    'lib/aurita/base/controller_methods.rb',
    'lib/aurita/base/exception/unknown_model.rb',
    'lib/aurita/base/exception/base_exception.rb',
    'lib/aurita/base/exception/auth_exception.rb',
    'lib/aurita/base/exception/parameter_exception.rb',
    'lib/aurita/base/exception/user_exception.rb',
    'lib/aurita/base/exceptions.rb',
    'lib/aurita/base/controller_response.rb',
    'lib/aurita/base/plugin_register.rb',
    'lib/aurita/base/log/class_logger.rb',
    'lib/aurita/base/log/system_logger.rb',
    'lib/aurita/base/routing.rb',
    'lib/aurita/base/controller.rb',
    'lib/aurita/base/bits/entities.rb',
    'lib/aurita/base/bits/hash.rb',
    'lib/aurita/base/bits/string.rb',
    'lib/aurita/base/bits/file.rb',
    'lib/aurita/base/bits/integer.rb',
    'lib/aurita/base/bits/cgi.rb',
    'lib/aurita/base/bits/time_ago.rb',
    'lib/aurita/base/bits/symbol.rb',
    'lib/aurita/base/bits/time.rb',
    'lib/aurita/base/bits/nil.rb',
    'lib/aurita/base/bits/array.rb',
    'lib/aurita/base/application.rb',
    'lib/aurita/base/session.rb',
    'lib/aurita/console/console_runner.rb',
    'lib/aurita/console/console_modules/reindex.rb',
    'lib/aurita/console/console_modules/import_local_folder.rb',
    'lib/aurita/console/console_modules/dispatch.rb',
    'lib/aurita/console/console_modules/vacuum.rb',
    'lib/aurita/console/console_modules/generate_image_variants.rb',
    'lib/aurita/console/console_modules/stats.rb',
    'lib/aurita/console/irb/console.rb',
    'lib/aurita/project_config.rb',
    'lib/aurita/env.rb',
    'lib/aurita/main/permissions.rb',
    'lib/aurita/main/model/user_group_hierarchy.rb',
    'lib/aurita/main/model/content_permissions.rb',
    'lib/aurita/main/model/content_recommendation.rb',
    'lib/aurita/main/model/user_profile.rb',
    'lib/aurita/main/model/tag_blacklist.rb',
    'lib/aurita/main/model/tag_synonym.rb',
    'lib/aurita/main/model/content_comment.rb',
    'lib/aurita/main/model/hierarchy.rb',
    'lib/aurita/main/model/category.rb',
    'lib/aurita/main/model/tag_relevance.rb',
    'lib/aurita/main/model/user_role.rb',
    'lib/aurita/main/model/content_access.rb',
    'lib/aurita/main/model/hierarchy_category.rb',
    'lib/aurita/main/model/content.rb',
    'lib/aurita/main/model/content_category.rb',
    'lib/aurita/main/model/user_category.rb',
    'lib/aurita/main/model/user_online.rb',
    'lib/aurita/main/model/component_position.rb',
    'lib/aurita/main/model/group_leader.rb',
    'lib/aurita/main/model/tag_index.rb',
    'lib/aurita/main/model/user_group.rb',
    'lib/aurita/main/model/content_history.rb',
    'lib/aurita/main/model/role_permission.rb',
    'lib/aurita/main/model/tag_feed.rb',
    'lib/aurita/main/model/plugin_permission.rb',
    'lib/aurita/main/model/hierarchy_entry.rb',
    'lib/aurita/main/model/user_action.rb',
    'lib/aurita/main/model/role.rb',
    'lib/aurita/main/model/user_login_data.rb',
    'lib/aurita/main/controllers/widget_service.rb',
    'lib/aurita/main/controllers/content_permissions.rb',
    'lib/aurita/main/controllers/app_my_place.rb',
    'lib/aurita/main/controllers/tag_whitelist.rb',
    'lib/aurita/main/controllers/context_menu.rb',
    'lib/aurita/main/controllers/content_recommendation.rb',
    'lib/aurita/main/controllers/app_news.rb',
    'lib/aurita/main/controllers/app_admin.rb',
    'lib/aurita/main/controllers/user_profile.rb',
    'lib/aurita/main/controllers/tag_blacklist.rb',
    'lib/aurita/main/controllers/tag_synonym.rb',
    'lib/aurita/main/controllers/app_main.rb',
    'lib/aurita/main/controllers/async_feedback.rb',
    'lib/aurita/main/controllers/content_comment.rb',
    'lib/aurita/main/controllers/app_my_base.rb',
    'lib/aurita/main/controllers/app_media.rb',
    'lib/aurita/main/controllers/hierarchy.rb',
    'lib/aurita/main/controllers/category.rb',
    'lib/aurita/main/controllers/user_role.rb',
    'lib/aurita/main/controllers/content.rb',
    'lib/aurita/main/controllers/content_category.rb',
    'lib/aurita/main/controllers/user_category.rb',
    'lib/aurita/main/controllers/autocomplete.rb',
    'lib/aurita/main/controllers/component_position.rb',
    'lib/aurita/main/controllers/user_group.rb',
    'lib/aurita/main/controllers/content_history.rb',
    'lib/aurita/main/controllers/role_permission.rb',
    'lib/aurita/main/controllers/app_general.rb',
    'lib/aurita/main/controllers/javascript.rb',
    'lib/aurita/main/controllers/hierarchy_entry.rb',
    'lib/aurita/main/controllers/role.rb',
    'lib/aurita/main/controllers/user_login_data.rb',
    'lib/aurita/config.rb',
    'lib/aurita/controller.rb',
    'lib/aurita/plugin.rb',
    'lib/aurita/application.rb',
    'lib/aurita/model.rb',
    'lib/aurita/modules/file_helpers.rb',
    'lib/aurita/modules/tree.rb',
    'lib/aurita/modules/tagging.rb',
    'lib/aurita/modules/gui/helpers.rb',
    'lib/aurita/modules/gui/async_upload_form_decorator.rb',
    'lib/aurita/modules/gui/module.rb',
    'lib/aurita/modules/gui/form_generator.rb',
    'lib/aurita/modules/gui/context_menu.rb',
    'lib/aurita/modules/gui/erb_template.rb',
    'lib/aurita/modules/gui/accordion_box.rb',
    'lib/aurita/modules/gui/datetime_helpers.rb',
    'lib/aurita/modules/gui/form_helper.rb',
    'lib/aurita/modules/gui/message_box.rb',
    'lib/aurita/modules/gui/autocomplete_result.rb',
    'lib/aurita/modules/gui/hierarchy.rb',
    'lib/aurita/modules/gui/button.rb',
    'lib/aurita/modules/gui/box.rb',
    'lib/aurita/modules/gui/user_icon.rb',
    'lib/aurita/modules/gui/lang.rb',
    'lib/aurita/modules/gui/link_helpers.rb',
    'lib/aurita/modules/gui/entity_table.rb',
    'lib/aurita/modules/gui/multi_file_entry_field.rb',
    'lib/aurita/modules/gui/context_menu_helpers.rb',
    'lib/aurita/modules/gui/tab_group.rb',
    'lib/aurita/modules/gui/erb_helpers.rb',
    'lib/aurita/modules/gui/async_form_decorator.rb',
    'lib/aurita/modules/gui/i18n_helpers.rb',
    'lib/aurita/modules/gui/parser.rb',
    'lib/aurita/modules/gui/format_helpers.rb',
    'lib/aurita/modules/gui/custom_form_elements.rb',
    'lib/aurita/modules/gui/error_page.rb',
    'lib/aurita/modules/gui/multi_file_field.rb',
    'lib/aurita/modules/gui/page.rb',
    'lib/aurita/modules/gui/hierarchy_node_select_field.rb',
    'lib/aurita/modules/permission.rb',
    'lib/aurita/modules/lore_manager.rb',
    'lib/aurita/modules/decorators/default.rb',
    'lib/aurita/modules/route.rb',
    'lib/aurita/modules/context_menu_helpers.rb',
    'lib/aurita/modules/cache/simple.rb',
    'lib/aurita/modules/categorized.rb',
    'lib/aurita/plugin_controller.rb',
    'bin/heartbeat/heartbeat-config.rb',
    'bin/generate_schema_dumps.rb',
    'README.rb'
  ]

  s.has_rdoc = true
  s.rdoc_options << '--title' << 'Aurita' <<
                    '--main' << 'README.rb' <<
                    '--line-numbers'

  s.homepage = 'http://intra.wortundform.de/doc/'

}
