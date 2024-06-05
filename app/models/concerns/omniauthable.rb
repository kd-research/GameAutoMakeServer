module Omniauthable
  extend ActiveSupport::Concern

  class_methods do
    # Find user by provider and uid
    # @param [Hash] auth
    # @option auth [String] :provider
    # @option auth [String] :uid
    # @option auth [Hash] :info
    # @return [User]
    def from_omniauth(auth)
      if (user_oauth = UserOauth.find_by(provider: auth[:provider], uid: auth[:uid]))
        user_oauth.user
      elsif find_by(email: auth.dig(:info, :email))
        raise Authorization::UserAlreadyExists, "User with email #{auth.dig(:info, :email)} already exists."
      else
        create_from_omniauth(auth)
      end
    end

    # When user is not found, create a new user with the information from the auth hash
    # Assign a
    # @param [ActionController::Parameters] auth
    # @return [User]
    def create_from_omniauth(auth)
      user = create!(email: auth.dig(:info, :email), password: Devise.friendly_token[0, 20])
      user.user_oauths.create!(provider: auth[:provider], uid: auth[:uid])

      fill_in_details(user, auth)
    end

    private

    # Fill in user details from the auth hash
    def fill_in_details(user, auth)
      fill_in_name(user, auth.dig(:info, :name))
      %i[avatar_url image].each do |key|
        if (value = auth.dig(:info, key))
          fill_in_avatar(user, value)
          break
        end
      end
      user
    end

    # Fill in user name
    def fill_in_name(user, name)
      return unless name

      user.user_profile.update!(name:)
    end

    # Fill in user avatar
    def fill_in_avatar(user, image_url)
      return unless image_url

      response = RestClient.get image_url
      return unless response.code == 200 && response.headers[:content_type].start_with?("image/")

      filename = "user-avatar.#{response.headers[:content_type].split('/').last}"
      user.user_profile.image.attach(io: StringIO.new(response.body), filename:)
    end
  end
end
