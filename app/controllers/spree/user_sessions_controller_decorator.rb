Spree::UserSessionsController.class_eval do
  before_action :wonderful_authentication, only: :new

  protected

  def wonderful_authentication
    method = Spree::AuthenticationMethod.wu_available_for(@spree_user).first

    redirect_to(
      spree.spree_user_omniauth_authorize_url(provider: method.provider)
    ) if method
  end
end
