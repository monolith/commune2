# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false



# Enable ruby-debug
require "ruby-debug"

# Mailer settings:
config.action_mailer.delivery_method = :smtp
config.action_mailer.default_url_options = { :host => 'commune2.com' }
ActionMailer::Base.smtp_settings = Test_mail_config

config.action_mailer.raise_delivery_errors = true
config.action_mailer.perform_deliveries = true
config.action_mailer.default_charset = 'utf-8'


# this deals with a memcache problem - describe here:
# http://kballcodes.com/2009/09/05/rails-memcached-a-better-solution-to-the-undefined-classmodule-problem/
# this should be in dev only

#  class << Marshal
#     def load_with_autoload(*args)
#       begin
#         load_without_autoload(*args)
#       rescue [ArgumentError, NameError] => ex
#         msg = ex.message
#         if msg =~ /undefined class\/module/
#           mod = msg.split(' ').last
#           if Dependencies.load_missing_constant(self, mod.to_sym)
#             load(*args)
#           else
#             raise ex
#           end
#         else
#           raise ex
#         end
#       end
#     end
#     alias_method :load_without_autoload, :load
#     alias_method :load, :load_with_autoload
#   end

