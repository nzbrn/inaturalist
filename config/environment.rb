$KCODE = 'UTF8'
# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.12' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'yaml'
INAT_CONFIG = YAML.load(File.open("#{RAILS_ROOT}/config/config.yml"))[RAILS_ENV]

# flickr api keys - these need to be set before Flickraw gets included
FLICKR_API_KEY = INAT_CONFIG['flickr']['FLICKR_API_KEY']
FLICKR_SHARED_SECRET = INAT_CONFIG['flickr']['FLICKR_SHARED_SECRET']
FlickRawOptions = {
  'api_key' => FLICKR_API_KEY,
  'shared_secret' => FLICKR_SHARED_SECRET
}
DEFAULT_SRID = -1 # nofxx-georuby defaults to 4326.  Ugh.

require "omniauth"
Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :key => INAT_CONFIG['rails']['session_key'],
    :secret => INAT_CONFIG['rails']['secret']
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # Added from the acts_as_authenticated plugin 6/3/07
  config.active_record.observers = :user_observer, :listed_taxon_sweeper
  
  # Gems, see also Gemfile
  config.gem 'pg'
  config.gem 'will_paginate', :version => '2.3.15'
  config.gem 'rubyist-aasm', :lib => 'aasm', :source => 'http://gems.github.com', :version => '2.0.2'
  config.gem "dbf", :version => "<= 1.2.9"
  config.gem "nofxx-georuby", :lib => 'geo_ruby'
  config.gem "spatial_adapter"
  config.gem "mojombo-chronic", :lib => 'chronic', :source => 'http://gems.github.com'
  config.gem 'bluecloth'
  config.gem "htmlentities"
  config.gem "aws-s3", :lib => 'aws/s3'
  config.gem "xml-simple", :lib => 'xmlsimple'
  config.gem "mime-types", :lib => 'mime/types'
  config.gem "mocha"
  config.gem "paperclip"
  config.gem "ambethia-smtp-tls", :lib => "smtp-tls", :source => "http://gems.github.com/"
  config.gem "flickraw"
  config.gem 'rest-client', :lib => 'rest_client'
  config.gem "carlosparamio-geoplanet", :lib => 'geoplanet', :source => "http://gems.github.com/"
  config.gem 'daemon-spawn', :lib => 'daemon_spawn'
  config.gem 'nokogiri'
  config.gem 'objectify-xml', :lib => 'objectify_xml'
  config.gem 'delayed_job'
  config.gem 'thinking-sphinx',
    :lib     => 'thinking_sphinx',
    :version => '< 2'
  config.gem 'ts-delayed-delta',
    :lib     => 'thinking_sphinx/deltas/delayed_delta'
  config.gem 'ancestry'
  config.gem 'machinist'
  config.gem 'faker'
  config.gem 'fastercsv'
  config.gem 'delayed_paperclip'
  config.gem "friendly_id", :version => "~> 3.2.1"
  config.gem "koala"
  config.gem "preferences"
  
  # Set default time zone to UTC
  config.time_zone = 'UTC'
end

# Windows flag, for disabling things that might not work in Windoze
WINDOWS = false

require 'geoplanet'
require 'net-flickr/lib/net/flickr'
require 'catalogue_of_life'
require 'ubio'
require 'model_tips'
require 'meta_service'
require 'wikipedia_service'
require 'batch_tools'
require 'geo_ruby/shp4r/shp'
require 'georuby_extra'
# require 'koala' # why does this have to be here...

### API KEYS ###
UBIO_KEY = INAT_CONFIG['ubio']['UBIO_KEY']

# Yahoo Developer Network
YDN_APP_ID = INAT_CONFIG['yahoo_dev_network']['YDN_APP_ID']
GeoPlanet.appid = YDN_APP_ID


# Google Analytics configs
# See http://www.rubaidh.com/projects/google-analytics-plugin/
Rubaidh::GoogleAnalytics.tracker_id   = INAT_CONFIG['google_analytics']['tracker_id']
Rubaidh::GoogleAnalytics.domain_name  = INAT_CONFIG['google_analytics']['domain_name']
Rubaidh::GoogleAnalytics.environments = ['production']

# General settings
SITE_NAME = INAT_CONFIG['general']['SITE_NAME']
OBSERVATIONS_TILE_SERVER = INAT_CONFIG['tile_servers']['observations']
SPHERICAL_MERCATOR = SphericalMercator.new

# Set the priority time zones for the time zone select lists
PRIORITY_ZONES = ActiveSupport::TimeZone.all.find_all { |z| z.name =~ %r{#{INAT_CONFIG['general']['priority_zones'].join('|')}} }

# Exception notifications
if INAT_CONFIG['exception_notifications']
  ExceptionNotification::Notifier.exception_recipients = INAT_CONFIG['exception_recipients']
  ExceptionNotification::Notifier.sender_address = %("#{SITE_NAME} Application Error" <#{INAT_CONFIG['noreply_email']}>)
  ExceptionNotification::Notifier.email_prefix = "[#{SITE_NAME} Error] "
end
