require 'spree_core'
require 'spree_auth_devise'
require 'omniauth-wonderful-union'
require 'coffee_script'

require 'spree_social/configuration'
require 'spree_social/engine'
require 'spree_social/version'

module SpreeSocial
  OAUTH_PROVIDERS = [
    %w(WonderfulUnion wonderful_union true),
  ]

  def self.configure(&block)
    yield configuration
  end

  def self.configuration
    @_configuration ||= Configuration.new
  end

  def self.authorization
    configuration.find_authentication_method.call
  end

  # Setup all OAuth providers
  def self.init_provider(provider)
    if ActiveRecord::Base.connection.table_exists?('spree_authentication_methods')
      key, secret = nil

      Spree::AuthenticationMethod.where(environment: ::Rails.env).each do |auth_method|
        next unless auth_method.provider == provider
        key = auth_method.api_key
        secret = auth_method.api_secret
        Rails.logger.info("[Spree Social] Loading #{auth_method.provider.capitalize} as authentication source")
      end
      setup_key_for(provider.to_sym, key, secret)
    end
  end

  def self.setup_key_for(provider, key, secret)
    Devise.setup do |config|
      config.omniauth provider, key, secret, options
    end
  end

  def self.options
    { setup: true }.tap do |options|
      override_url = ENV.fetch("WUN_GATEKEEPER_SITE_URL", false)

      if override_url
        options[:client_options] = {
          site: override_url,
          authorize_url: "#{override_url}/oauth/authorize",
          token_url: "#{override_url}/oauth/token"
        }
      end
    end
  end
end
