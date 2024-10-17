require "test_helper"

module ScoreBoard
  class ScoreTest < ActiveSupport::TestCase
    def setup
      @client_terminal = ClientTerminal.create!
      @published_game = PublishedGame.create!
      @score = Score.create!(
        value: 100,
        client_terminal: @client_terminal,
        published_game: @published_game
      )
    end

    test "should belong to client_terminal" do
      assert_equal @client_terminal, @score.client_terminal
    end

    test "should belong to published_game" do
      assert_equal @published_game, @score.published_game
    end

    test "should have only the 'value' attribute" do
      expected_attributes = ["id", "value", "client_terminal_id", "published_game_id", "created_at", "updated_at"]
      actual_attributes = @score.attributes.keys
      unexpected_attributes = actual_attributes - expected_attributes
      assert_empty unexpected_attributes, "Unexpected attributes found: #{unexpected_attributes.join(', ')}"
    end

    test "value should be present" do
      @score.value = nil
      assert_not @score.valid?, "Score is valid without a value"
    end
  end
end

