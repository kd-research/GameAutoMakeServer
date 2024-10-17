# test/models/published_game_test.rb
require 'test_helper'

class PublishedGameTest < ActiveSupport::TestCase
  def setup
    @published_game = PublishedGame.create!
    @client_terminal = ClientTerminal.create!

    @score1 = ScoreBoard::Score.create!(
      value: 200,
      client_terminal: @client_terminal,
      published_game: @published_game
    )
    @score2 = ScoreBoard::Score.create!(
      value: 150,
      client_terminal: @client_terminal,
      published_game: @published_game
    )
    @score3 = ScoreBoard::Score.create!(
      value: 100,
      client_terminal: @client_terminal,
      published_game: @published_game
    )
  end

  test "should have many scores" do
    assert_equal 3, @published_game.scores.count
    assert_includes @published_game.scores, @score1
    assert_includes @published_game.scores, @score2
    assert_includes @published_game.scores, @score3
  end

  test "leaderboard should return top scores ordered by value descending" do
    leaderboard = @published_game.leaderboard
    assert_equal [@score1, @score2, @score3], leaderboard.to_a
  end

  test "leaderboard limit works" do
    leaderboard = @published_game.leaderboard(limit: 2)
    assert_equal [@score1, @score2], leaderboard.to_a
  end
end

