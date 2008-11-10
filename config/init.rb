# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'

dependency "facets", "2.4.5"
dependency "hpricot"
Merb.push_path(:lib, Merb.root / "lib")

use_orm :datamapper
use_test :rspec
use_template_engine :erb
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = '479a946f733b33305d6440802d59c93b471e81ca'  # required for cookie session store
  # c[:session_id_key] = '_session_id' # cookie session id key, defaults to "_session_id"
end
 
Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
  GLOBE_API_USERNAME = 'pvuuze'
  GLOBE_API_PIN = 'bKBCdnWuf0'
  GLOBE_SERVICE_NO = '23730244'
  MSG_HOW_TO_STOP = "Send 'STOP' to #{GLOBE_SERVICE_NO} to stop receiving sponsored messages."
  MSG_HOW_TO_ALLOW = "Send 'ALLOW' to #{GLOBE_SERVICE_NO} to allow receiving sponsored messages."
  MSG_NEW_SUBSCRIBER_INTRO = "#{GLOBE_SERVICE_NO} is an Ad service used by someone who sent you a message. #{MSG_HOW_TO_STOP}"
  MSG_STOPPED = "You will no longer receive sponsored messages. #{MSG_HOW_TO_ALLOW}"
  MSG_ALLOWED = "You can now receive sponsored messages. #{MSG_HOW_TO_STOP}"
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
  Numeric::Transformer.formats[:ph] = { :number => { :delimiter => ",", :separator => ".", :precision => 3 },
                                        :currency => { :unit => "Php ", :format => "%u%n", :precision => 2 } }
end
