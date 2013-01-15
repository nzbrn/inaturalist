Inaturalist::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The staging environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local                   = false
  config.action_controller.perform_caching             = true
  config.action_view.cache_template_loading            = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # Set the logger to roll over
  config.logger = Logger.new("#{Rails.root}/log/#{Rails.env}.log", 10, 10485760)

  # Not sure why this is necessary, but settings the custom logger above 
  # seems to cause ActiveRecord to log db statements
  config.active_record.logger = nil

  # Use a different cache store in staging
  config.cache_store = :mem_cache_store, INAT_CONFIG["memcached"]

  # Disable Rails's static asset server
  # In staging, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => 'staging.naturewatch.egressive.com' }
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.default :charset => "utf-8"

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  if INAT_CONFIG['google_analytics'] && INAT_CONFIG['google_analytics']['tracker_id']
    config.middleware.use "Rack::GoogleAnalytics", :web_property_id => INAT_CONFIG['google_analytics']['tracker_id']
  end
end
