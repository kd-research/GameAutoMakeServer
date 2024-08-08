class ConnectPolymorphicGameCompiles < ActiveRecord::Migration[7.1]
  def up
    HtmlGameCompile.all.each do |html_game_compile|
      GameCompile.create!(
        game_project_id: html_game_compile.game_project_id,
        gameable_id: html_game_compile.id,
        gameable_type: 'HtmlGameCompile'
      )
      HtmlGameCompile.update_all(model_type: 'HtmlGameCompile')
    end

    WebglGameCompile.all.each do |webgl_game_compile|
      GameCompile.create!(
        game_project_id: webgl_game_compile.game_project_id,
        gameable_id: webgl_game_compile.id,
        gameable_type: 'WebglGameCompile'
      )
    end
  end

  def down
    HtmlGameCompile.all.each do |html_game_compile|
      html_game_compile.update!(game_project_id: html_game_compile.game_compile.game_project_id)
    end

    WebglGameCompile.all.each do |webgl_game_compile|
      webgl_game_compile.update!(game_project_id: webgl_game_compile.game_compile.game_project_id)
    end
  end
end
