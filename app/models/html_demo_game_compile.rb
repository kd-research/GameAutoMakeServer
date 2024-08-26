class HtmlDemoGameCompile < HtmlGameCompile
  def self.compile_by_llm(_name, _description)
    OpenStruct.new(
      html: OpenStruct.new(
        data: "Hello, World!"
      )
    )
  end
end
