require "test_helper"

class CustomizeGameServiceTest < ActiveSupport::TestCase
  SERVICE_METHODS = %i[
    game_design_document_reconstruction
    html5_game_modification_export
    theme_design_generate
    game_icon_prompt_generate
    game_icon_generate
  ]
  setup do
    @customization_messages = JSON.load_file(Rails.root.join("test/fixtures/game_customize.json"))
    @service = CustomizeGameService.new
  end

  test "should refine game modification document" do
    mod_request = @customization_messages.dig("match3", 0)
    html_content = get_match3_html

    assume_game_design_document_reconstruction_success(html_content, mod_request)
    response = @service.game_design_document_reconstruction(html_content, mod_request)
    puts(response.transform_values { |v| (v.is_a? String) ? v[0..100] : v.class.to_s })

    suggested_name = response[:suggested_name]
    modified_doc = response[:modified_doc]

    assume_html5_game_modification_export_success(html_content, modified_doc)
    response = @service.html5_game_modification_export(html_content, modified_doc)
    puts(response.transform_values { |v| (v.is_a? String) ? v[0..100] : v.class.to_s })

    modify_status = response[:success]
    modified_html = response[:html]
  end

  test "should capture error when game modification document is invalid" do
    html_content = "<html><body><h1>Test</h1></body></html>"
    modified_doc = "This is an explicit error for testing purposes. You should consider this as a modification out of scope."
    response = @service.html5_game_modification_export(html_content, modified_doc)
    puts(response.transform_values { |v| (v.is_a? String) ? v[0..100] : v.class.to_s })

    assert_not response[:success]
    assert_predicate response[:reason], :present?
  end

  test "should generate theme and game icon" do
    mod_request = @customization_messages.dig("match3", 0)
    html_content = get_match3_html

    assume_game_design_document_reconstruction_success(html_content, mod_request)
    response = @service.game_design_document_reconstruction(html_content, mod_request)
    puts(response.transform_values { |v| (v.is_a? String) ? v[0..100] : v.class.to_s })

    suggested_name = response[:suggested_name]
    modified_doc = response[:modified_doc]

    assume_theme_design_generate_success(modified_doc)
    response = @service.theme_design_generate(modified_doc)
    puts(response.transform_values { |v| (v.is_a? String) ? v[0..100] : v.class.to_s })

    theme_design = response[:theme_design]
    assume_game_icon_prompt_generate_success(theme_design)
    response = @service.game_icon_prompt_generate(theme_design)
    puts(response.transform_values { |v| (v.is_a? String) ? v[0..100] : v.class.to_s })

    game_icon_prompt = response[:game_icon_prompt]
    # assume_game_icon_generate_success(game_icon_prompt)
    response = @service.game_icon_generate(game_icon_prompt)
    puts(response.transform_values { |v| (v.is_a? String) ? v[0..100] : v.class.to_s })

    binding.pry
  end

  test "should complete integrated customization workflow" do
    mod_request = @customization_messages.dig("match3", 0)
    html_content = get_match3_html

    # To ensure a full integration, we assume each sub-service works as expected.
    assume_game_design_document_reconstruction_success(html_content, mod_request)
    reconstruction = @service.game_design_document_reconstruction(html_content, mod_request)
    suggested_name = reconstruction[:suggested_name]
    modified_doc = reconstruction[:modified_doc]

    assume_html5_game_modification_export_success(html_content, modified_doc)
    export_response = @service.html5_game_modification_export(html_content, modified_doc)
    assert export_response[:success], "Expected HTML export to succeed"

    assume_theme_design_generate_success(modified_doc)
    theme_response = @service.theme_design_generate(modified_doc)
    theme_design = theme_response[:theme_design]

    assume_game_icon_prompt_generate_success(theme_design)
    prompt_response = @service.game_icon_prompt_generate(theme_design)
    game_icon_prompt = prompt_response[:game_icon_prompt]

    # For game icon generation, we may optionally stub to avoid actual image generation.
    # Uncomment the line below if you wish to stub game_icon_generate.
    @service.stubs(:game_icon_generate).with(game_icon_prompt).returns({ image: "fake_image_data", raw: {} })

    icon_response = @service.game_icon_generate(game_icon_prompt)
    assert icon_response[:image].present?, "Expected a generated game icon image"

    # Call the integrated workflow
    integrated_response = @service.integrated_customization(html_content, mod_request)

    # Log a short preview of the outputs
    puts integrated_response.transform_values { |v| v.is_a?(String) ? v[0..100] : v.inspect }

    # Assertions for integrated response
    assert integrated_response[:suggested_name].present?, "Expected a suggested game name"
    assert integrated_response[:modified_html].present?, "Expected modified html content"
    assert integrated_response[:game_icon_image].present?, "Expected a game icon image"
    # game_splash_image is still a TODO
    assert_nil integrated_response[:game_splash_image], "Expected game splash image to be nil (TODO)"
  end

  private

  def get_match3_html
    File.read(Rails.root.join("test/fixtures/files/match_3_orig.html"))
  end

  # Define methods to assume success for all service methods
  SERVICE_METHODS.each do |method_name|
    define_method(:"assume_#{method_name}_success") do |*args|
      @service.stubs(method_name).with(*args).returns begin
        mock_file_path = Rails.root.join(
          "test/fixtures/mocks",
          "service-#{method_name}-#{Digest::SHA256.hexdigest(args.join)}.json"
        )

        unless File.exist?(mock_file_path)
          raise "Mock file not found: #{mock_file_path}. Run tests interactively to generate mocks." unless STDIN.tty?

          puts "\nMock file not found: #{mock_file_path}"
          print "Would you like to generate and store a new mock response? (y/n): "
          user_input = STDIN.gets.chomp.downcase

          raise "Test aborted: Missing mock file #{mock_file_path} and user declined to generate one." unless user_input == "y"

          puts "Calling actual service method to generate mock data..."
          # Remove the stub so that the real method is called
          service_with_no_stubs = CustomizeGameService.new
          response = service_with_no_stubs.send(method_name, *args)
          File.write(mock_file_path, JSON.generate(response))
          puts "Mock file saved: #{mock_file_path}"

        end

        JSON.load_file(mock_file_path).symbolize_keys
      end
    end
  end
end
