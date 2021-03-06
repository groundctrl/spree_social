class Spree::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Store

  def wonderful_union
    auth_provider = auth_hash['provider'].titleize

    if request.env['omniauth.error'].present?
      flash[:error] = I18n.t('devise.omniauth_callbacks.failure', kind: auth_provider, reason: Spree.t(:user_was_not_valid))
      redirect_back_or_default(root_url)
      return
    end

    authentication = Spree::UserAuthentication.find_by_provider_and_uid(auth_hash['provider'], auth_hash['uid'])

    if authentication.try(:user).present?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: auth_provider)
      sign_in_and_redirect :spree_user, authentication.user
    elsif spree_current_user
      spree_current_user.apply_omniauth(auth_hash)
      spree_current_user.save!
      flash[:notice] = I18n.t('devise.sessions.signed_in')
      redirect_back_or_default(account_url)
    else
      user = Spree::User.find_by_email(auth_hash['info']['email']) || Spree::User.new
      user.apply_omniauth(auth_hash)
      if user.save
        flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: auth_provider)
        sign_in_and_redirect :spree_user, user
      else
        session[:omniauth] = auth_hash.except('extra')
        flash[:notice] = Spree.t(:one_more_step, kind: auth_provider)
        redirect_to new_spree_user_registration_url
        return
      end
    end

    if current_order
      user = spree_current_user || authentication.user
      current_order.associate_user!(user)
      session[:guest_token] = nil
    end
  end

  def failure
    set_flash_message :alert, :failure, kind: failed_strategy.name.to_s.humanize, reason: failure_message
    redirect_to root_path
  end

  def passthru
    render file: "#{Rails.root}/public/404", formats: [:html], status: 404, layout: false
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def setup
    request.env['omniauth.strategy'].options[:client_id] =
      social_auth_method.api_key
    request.env['omniauth.strategy'].options[:client_secret] =
      social_auth_method.api_secret

    render text: 'Setup complete.', status: 404
  end

  private

  def social_auth_method
    SpreeSocial.authorization
  end
end
