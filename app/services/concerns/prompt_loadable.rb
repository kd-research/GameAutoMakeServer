module PromptLoadable
  extend ActiveSupport::Concern


  def load_prompt(filename)
    suffixes = %w[.md .txt .erb]
    suffixes.each do |suffix|
      file_path = Rails.root.join('app', 'services', 'prompts', "#{filename}#{suffix}")
      puts "Checking file: #{file_path}"
      if File.exist?(file_path)
        return File.read(file_path)
      end
    end

    raise "Prompt file not found: #{filename}"
  end
end
