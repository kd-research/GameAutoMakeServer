module JsonRetouchHelper
  def json_retouch(str)
    JSON.pretty_generate(JSON.parse(str))
  end
end
