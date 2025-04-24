module Android
  class HotPatchGame < ApplicationRecord
    has_one_attached :icon
    has_one_attached :splash
    has_one_attached :html

    def need_review?
      groups.include?("pending-review")
    end

    def reviewed!
      update(groups: groups.split(",").reject { |group| group == "pending-review" }.join(","))
    end
  end
end
