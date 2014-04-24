$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'prerender/web'

run Prerender::Web.new
