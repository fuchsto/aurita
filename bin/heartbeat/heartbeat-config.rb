# Konfiguration heartbeat.rb

# Was wird in Mails angegeben als Servername?
MY_NAME = "intra.wortundform.de"

# Wohin werden Mails verschickt?
# E-Mail-Adresse oder Array von mehreren
MAILTO_ADDRESS = [
	'diehr@wortundform.de',
	'gnaier@wortundform.de',
	'fuchs@wortundform.de'
]

MAX_INVOCATIONS_PER_DAY = 50

THROTTLE_FILE = File.dirname(__FILE__) + "/throttle.yaml"
LOG_FILE      = File.dirname(__FILE__) + "/heartbeat.log"

# Shellcode zum Restarten des Servers
RESTART_CODE = <<END
/usr/share/svnwc/aurita/bin/flush
END

# Welche URL soll abgerufen werden?
CHECK_URL = 'http://intra.wortundform.de/aurita/App_Main/ping/'

# Welche Strings muessen in der Ausgabe auftauchen?
CHECK_STRINGS = [
      [ 'AURITA ALIVE', 'No ping response' ]
]


# Beispiel fuer wuerttfv.de
# 'http://85.10.207.145/engines/redition/project/dispatcher.fcgi?x=1920&y=1200&id=home&cid='
#[
#      [ '<title>Dispatcher</title>', 'title tag not found' ],
#      [ '<link href="/project/inc/site_public.css.fcgi', 'css not found' ],
#      [ '</body>', 'closing body tag not found' ],
#      [ '</html>', 'closing html tag not found' ]
#]
