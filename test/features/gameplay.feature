Feature: Gameplay
  Background:
    Given a bingo game is in progress
    And 5 players have joined the game
    And each player has a unique bingo card

  Scenario: New number is drawn periodically
    When 3 minutes have passed since the last number was drawn
    Then a new bingo number should be drawn
    And the new number should be announced to all players
    And the drawn number should be marked as called in the game state

  Scenario: Player claims bingo with a valid winning card
    Given a player has a bingo card with a winning pattern
    When the player claims bingo
    Then the game should verify the player's bingo card
    And the player should be declared the winner
    And the prize pot should be transferred to the winner's wallet
    And the game state should change to "Completed"

  Scenario: Player claims bingo with an invalid card
    Given a player has a bingo card without a winning pattern
    When the player claims bingo
    Then the game should verify the player's bingo card
    And the claim should be rejected as invalid
    And the player should be notified that their claim was invalid
    And the game should continue
    And the next number should be drawn after the standard time interval
    