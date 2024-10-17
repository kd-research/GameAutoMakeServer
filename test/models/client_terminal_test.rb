require "test_helper"

class ClientTerminalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @client_terminal = ClientTerminal.create!
    @published_game = PublishedGame.create!
    @score1 = ScoreBoard::Score.create!(
      value: 100,
      client_terminal: @client_terminal,
      published_game: @published_game
    )
    @score2 = ScoreBoard::Score.create!(
      value: 100,
      client_terminal: @client_terminal,
      published_game: @published_game
    )
  end

  test "should have many scores" do
    assert_includes @client_terminal.scores, @score1
    assert_includes @client_terminal.scores, @score2
  end
end
