class HtmlCompileJob < ApplicationJob
  queue_as :compile

  def perform(game_compile)
    game_compile.update!(status: 'compiling')
    game_compile.compile_html
  end
end
