class HtmlStableCompile < HtmlGameCompile
  def self.compile_by_llm(name, description)
    GameGenerator::CrewClientStable.new.generate_html_game(name:, description:)
  end
end
