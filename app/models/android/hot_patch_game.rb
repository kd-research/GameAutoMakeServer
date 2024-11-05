module Android
  class HotPatchGame < ApplicationRecord
    has_one_attached :icon
    has_one_attached :splash
    has_one_attached :html
  end
end
