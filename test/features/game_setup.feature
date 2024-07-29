Feature: Game Setup and Joining

  Background:
    Given a bingo game smart contract is deployed
    And the game cost is set to 0.1 ETH
    And the maximum number of players is set to 5

  Scenario: Player views the cost of joining a game
    When a player checks the game cost
    Then they should see that the cost is 0.1 ETH

  Scenario: Player joins a new bingo game
    Given there is an active bingo game waiting for players
    And the player has sufficient funds
    When the player attempts to join the game
    Then the player should be successfully added to the game
    And the number of players in the game should increase by 1

  @failure
  Scenario: Player attempts to join a full game
    Given the game has reached the maximum number of players
    When a new player tries to join the game
    Then the player should not be added to the game
    And an error message should be displayed, such as "Game is full"

  Scenario: Game collects cost from player on joining
    Given a player has more than 0.1 ETH in their wallet
    When the player joins the game
    Then 0.1 ETH should be transferred from the player's wallet to the game contract
    And the game's prize pot should increase by 0.1 ETH

  Scenario: Game begins when maximum players have joined
    Given 4 players have already joined the game
    When the 5th player joins the game
    Then the game state should change to "In Progress"
    And each player should be assigned a unique bingo card

  Scenario: Bingo board is generated for player on joining
    Given a player has joined the game
    When the system generates a bingo board
    Then the player should receive a unique bingo board
    And the board should have a valid bingo configuration
