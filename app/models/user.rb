class User < ApplicationRecord
  include ::Omniauthable

  omniauth_providers = %i[github]
  omniauth_providers << :developer unless Rails.env.production?

  devise(:database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers:)

  has_one :user_profile, dependent: :destroy
  has_many :user_oauths, dependent: :destroy
  has_many :game_projects, dependent: :destroy

  after_create :create_user_profile

  def admin?
    roles.split(',').include?('admin')
  end

  private

  def create_user_profile
    self.user_profile = UserProfile.create!(user: self)
  end
end
