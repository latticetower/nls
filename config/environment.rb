# Be sure to restart your server when you modify this file
# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
Dir["#{RAILS_ROOT}/app/ui/*.rb"].each(&:require) #for active scaffold ui

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  config.gem 'russian', :source => 'http://gemcutter.org'
  config.gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'inherited_resources', :version => '1.0.6'  ##, :source => 'http://gems.github.com'
  config.gem 'formtastic', :version => '1.2.3'
 ##config.gem 'cancan'
  config.gem 'zipruby'
  #config.gem 'libxml-ruby' 
  # config.gem 'libxslt-ruby' 
  
 config.gem 'splattael-activerecord_base_without_table', :lib    => 'activerecord_base_without_table',
                                                            :source => 'http://gems.github.com'

                                                            
  config.gem 'ruby-rtf',
               :source => 'http://gems.github.com'

                                                            #https://github.com/thechrisoshow/rtf
 #config.gem 'cucumber', :lib =>'cucumber', :source => 'git://github.com/aslakhellesoy/cucumber.git'
  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
config.time_zone = 'Moscow'
config.i18n.default_locale = :ru
#Russian::init_i18n
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.active_record.observers = :user_observer #, :user_message_observer, :filemanager_observer
   
   config.action_mailer.smtp_settings = {
	   :address  => '***REMOVED***',
	   :port => 25,
	   :domain => '***REMOVED***',
	   :authentication  => :login,
	   :user_name => "***REMOVED***",
	   :password => "***REMOVED***"
   } 
   config.action_mailer.delivery_method = :smtp
   config.action_mailer.raise_delivery_errors = true
   config.action_mailer.perform_deliveries = true
   config.action_mailer.default_charset = 'utf-8'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end


require "will_paginate"
#LiveValidations.use :jquery_validations, :validator_settings => {:debug => true, :onsubmit => true, :errorClass => "invalid"}
  
 ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
  :default => "%d.%m.%Y %H:%M",
 :time => "%H:%M",
 :full => "%d %B %Y",
 :date_only => "%d.%m.%Y"
 )