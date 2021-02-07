# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: :github
    before_action :github_user

    def github
      @auth = request.env['omniauth.auth']

      if successful_integration_creation
        redirect_to(
          integrations_path,
          notice: 'Github integration has been added'
        )
      else
        redirect_to(
          integrations_path,
          alert: 'Github was unable to add integration. Contact support if this issue persists.'
        )
      end
    end

    private

    def github_user
      @user = User.from_omniauth(request.env['omniauth.auth'])

      if @user.persisted?
        sign_in @user, event: :authentication # this will throw if @user is not activated
        redirect_to new_accounts_path(plan: 'starter')
        set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
      else
        # Removing extra as it can overflow some session stores
        session['devise.github_data'] = request.env['omniauth.auth'].except(:extra)
      end
    end

    def create_github_integration
      Integrations::Github.create!(
        account_id: current_account.id,
        settings: {
          token: @auth.credentials.token
        }
      )
    end

    def successful_integration_creation
      @auth != :invalid_credentials &&
        @auth&.credentials&.token &&
        create_github_integration
    end
  end
end
