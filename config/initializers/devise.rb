SpreeSocial::OAUTH_PROVIDERS.each do |provider|
  SpreeSocial.init_provider(provider[1])
end

OmniAuth.config.logger = Logger.new(STDOUT)
OmniAuth.logger.progname = 'omniauth'

OmniAuth.config.on_failure = proc do |env|
  devise_scope = Spree.user_class.table_name.split('.').last.singularize.to_sym
  env['devise.mapping'] = Devise.mappings.fetch(devise_scope)
  controller_name = ActiveSupport::Inflector.camelize(
    env['devise.mapping'].controllers[:omniauth_callbacks]
  )
  controller_class = ActiveSupport::Inflector.constantize(
    "#{controller_name}Controller"
  )
  controller_class.action(:failure).call(env)
end
