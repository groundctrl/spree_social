require 'spree_core'
require 'spree_auth_devise'
require 'omniauth-wonderful-union'
require 'spree_social/engine'
require 'spree_social/version'
require 'coffee_script'

module SpreeSocial
  OAUTH_PROVIDERS = [
    %w(WonderfulUnion wonderful_union true),
  ]

  def self.configure(&block)
    yield self
  end

  def self.authorization_proc=(auth_proc)
    @authorization_proc = auth_proc
  end

  def self.authorization
    if @authorization_proc
      @authorization_proc.call
    else
      Spree::AuthenticationMethod.find_by!(environment: ::Rails.env)
    end
  end

  # Setup all OAuth providers
  def self.init_provider(provider)
    return unless ActiveRecord::Base.connection.table_exists?('spree_authentication_methods')
    key, secret = nil
    Spree::AuthenticationMethod.where(environment: ::Rails.env).each do |auth_method|
      next unless auth_method.provider == provider
      key = auth_method.api_key
      secret = auth_method.api_secret
      Rails.logger.info("[Spree Social] Loading #{auth_method.provider.capitalize} as authentication source")
    end
    setup_key_for(provider.to_sym, key, secret)
  end

  def self.setup_key_for(provider, key, secret)
    Devise.setup do |config|
      config.omniauth provider, key, secret, setup: true
    end
  end
end
