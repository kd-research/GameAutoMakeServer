json.extract! android_hot_patch_game, :id, :name, :icon, :html, :created_at, :updated_at
json.url android_hot_patch_game_url(android_hot_patch_game, format: :json)
json.icon url_for(android_hot_patch_game.icon)
json.html url_for(android_hot_patch_game.html)
if android_hot_patch_game.splash.present?
  json.splash url_for(android_hot_patch_game.splash)
end
