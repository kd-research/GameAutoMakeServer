class PatchPlatform < Sinatra::Base
  def initialize(url_base = "")
    @base_url = url_base
    @file_mem = {}
    @service_epoch = Time.new(2024, 1, 1, 0, 0, 0).strftime("%s%L").to_i
    @token_gen = AnyFlake.new(@service_epoch, 0)
    super
  end

  def remove_old_files
    is_old = ->(key) { 2.hours.ago > AnyFlake.parse(key, @service_epoch).fetch(:time) }

    @file_mem.each_key
             .filter(&is_old)
             .each { |key| @file_mem.delete(key) }
  end

  def add_file(file)
    remove_old_files
    token = @token_gen.next_id
    @file_mem[token] = file
    token
  end

  get "/" do
    slim :patch_platform
  end

  post "/" do
    if params[:file] &&
       (tmpfile = params[:file][:tempfile]) &&
       (name = params[:file][:filename])

      buffer = tmpfile.read
      result = modify_buffer(buffer)
      token = add_file({ name:, buffer: result })
      "Download it <a href='#{@base_url}/#{token.to_s(36)}'>here</a>" +
        "<br>Link will expire in 2 hours"

    else
      redirect "/"
    end
  end

  get "/:id" do
    return "File not found" unless (file = @file_mem[params[:id].to_i(36)])

    content_type "application/octet-stream"
    attachment "patched_#{file.fetch(:name)}"
    file.fetch(:buffer)
  end

  run! if app_file == $0
end

def modify_buffer(buffer)
  # Modify the buffer here
  doc = Nokogiri::HTML(buffer)
  new_node = Nokogiri::XML::Node.new("script", doc)
  new_node.content = <<~JS
    const Platform = {
        majorVersion: function() { return 1; },
        minorVersion: function() { return 0; },
        setHighestScore: function(score) { console.log("setHighestScore", score); },
        getHighestScore: function() { return 0; },
        getSoundVolume: function() { return 50; },
        getProferredDifficulty: function() { return 3; },
      }
  JS
  override_content = <<~JS
    if (Platform.majorVersion() !== 1) {
      throw new Error("Unsupported platform version");
    }

    // Platform version 1.x provides the following functions:
    // All numbers are integer numbers
    // Platform.majorVersion() => number
    // Platform.minorVersion() => number
    // Platform.setHighestScore(score: number) => void
    // Platform.getHighestScore() => number
    // Platform.getSoundVolume() => number // in range [0-100]
    // Platform.getPreferredDifficulty() => number  // 0 = easy, 1 = medium, 2 = hard, 3 = no-preference
  JS

  doc.at("head script").tap do |node|
    node.before(new_node)
    node.content = override_content
  end

  doc.to_html
end
