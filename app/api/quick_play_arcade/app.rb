module QuickPlayArcade
  class App < Grape::API
    mount QuickPlayArcade::V2
    mount QuickPlayArcade::V1
  end
end
