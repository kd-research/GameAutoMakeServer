module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def default
      @user = User.from_omniauth(parameter: oauth_params)
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: oauth_params[:provider].capitalize) if is_navigational_format?
    rescue Authorization::UserAlreadyExists
      redirect_to root_path, alert: "Email already exists, please sign in with email and password."
    end

    alias developer default
    alias github default

    def failure
      redirect_to root_path
    end

    private

    def oauth_params
      omniauth_params = ActionController::Parameters.new(request.env["omniauth.auth"])
      omniauth_params.permit(:provider, :uid, info: %i[email name])
    end
  end
end
