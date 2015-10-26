Spree::UserSessionsController.class_eval do
  before_action :redirect_to_wonderful_union,
    only: :new,
    if: :wonderful_union_available?

  protected

  def redirect_to_wonderful_union
    redirect_to(
      spree.spree_user_omniauth_authorize_url(provider: "wonderful_union")
    )
  end

  def wonderful_union_available?
    Spree::AuthenticationMethod.available_for(@spree_user).
      where(active: true, provider: "wonderful_union").any?
  end
end
