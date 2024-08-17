class HtmlNightlyCompile < HtmlGameCompile
  private

  def self.compile_by_llm(name, description)
    GameGenerator::CrewClientNightly.new.generate_html_game(name:, description:)
  end
end
