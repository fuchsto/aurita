
require 'aurita'

Aurita.load_project :spec

Lore.logfile = STDERR
Lore.enable_query_log
Lore.logger.level       = Logger::DEBUG
Lore.query_logger.level = Logger::DEBUG

require './spec_helpers'

