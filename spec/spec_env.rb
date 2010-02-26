
require 'aurita'

Aurita.load_project :spec

Lore.logfile = STDERR
Lore.enable_query_log
Lore.logger.level       = Logger::DEBUG
Lore.query_logger.level = Logger::DEBUG
# Lore.add_login_data 'test' => [ 'paracelsus', nil ]

require '../spec_helpers'

