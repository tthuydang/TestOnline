require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TestOnline
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    ActionMailer::Base.smtp_settings = {
      :address => "smtp.gmail.com",
      :domain => "mail.google.com",
      :port => 587,
      :users_name => "nguyensontung183@gmail.com",
      :password => "123123",
      :authentication => "login",
      :enable_starttls_auto => true,
    }
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
