require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EmrbearBlog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.active_job.queue_adapter = :delayed_job # FGJ
    # FGJ. all stuff in app should be automatic? Be explicit anyways.
    config.autoload_paths += %W["#{config.root}/app/validators/"]
    config.autoload_paths += %W["#{config.root}/app/presenters/"]
    # lib: MyHelpers, Texter, ...
    config.autoload_paths += %W["#{config.root}/app/lib/"]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # autoload stuff in lib dirs
    # config.autoload_paths << Rails.root.join('lib')
    # Pulled at rails 5, can cause problems, put stuff in app/lib
  end
end
