module HtmlGameCompilesHelper
  def encode_html(html)
    encode64(fix_html_bytes(html))
  end

  def fix_html_bytes(html)
    # remove markdown fences at the beginning and end of the html
    html.gsub(/^```html\n/, "")
        .gsub(/```\n?$/, "")
  end

  def encode64(html)
    Base64.strict_encode64(html).delete("\n")
  end
end
