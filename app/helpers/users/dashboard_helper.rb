module Users
  module DashboardHelper
    def current_profile
      @current_profile ||= current_user.user_profile
    end

    def image_or_default
      current_profile.image.attached? ? current_profile.image : "default.png"
    end
  end
end
