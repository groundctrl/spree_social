Spree::UserSessionsController.class_eval do
  before_action :wonderful_authentication, only: :new

  protected

  def wonderful_authentication
    redirect_to(
      spree.spree_user_omniauth_authorize_url(provider: "wonderful_union")
    ) if wonderful_union_available?
  end

  def wonderful_union_available?
    Spree::AuthenticationMethod.available_for(@spree_user).
      where(active: true)
  end
end
