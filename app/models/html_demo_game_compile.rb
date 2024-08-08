class HtmlDemoGameCompile < HtmlGameCompile
  before_save
  private

  def self.compile_by_llm(name, description)
    OpenStruct.new(
      html: OpenStruct.new(
        data: "Hello, World!"
      ),
    )
  end
end
