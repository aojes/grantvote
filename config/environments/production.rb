# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

config.action_mailer.delivery_method       = :smtp #:sendmail
config.action_mailer.raise_delivery_errors = true
config.action_mailer.default_charset       = "utf-8"
config.action_mailer.perform_deliveries    = true

config.action_mailer.smtp_settings = {
    #:enable_starttls_auto => true,
    :address        => 'smtp.gmail.com',
    :port           => 587,
    :domain         => 'grantvote.com',
    :authentication => :plain,
    :user_name      => 'support@grantvote.com',
    :password       => 'big-upside09'
  }


# ActionView:: Template or TemplateHandler ( register haml extension )

# Enable threaded mode
# config.threadsafe!

#config.after_initialize do
#  ActiveMerchant::Billing::Base.mode = :test
#  paypal_options = {
#    :login => "grantv_1243695073_biz_api1.gmail.com",
#    :password => "1243695084",
#    :signature => "AyB-j3GrLTPVJLRaSugnRkXHG7iOAxlkJirxjqbFn4umeMQWMNWvAQFs"
#  }
#  ::STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)
#  ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
#
#end

