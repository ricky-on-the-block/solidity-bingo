// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {Bingo} from "../src/Bingo.sol";

contract TestGameSetup is Test {
    Bingo public bingo;
    uint256 public constant EXPECTED_GAME_COST = 100 gwei;

    function setUp() public {
        bingo = new Bingo();
    }

    function test_GameCost() public view {
        // Given the game cost is set to 100 gwei
        // When we call getGameCost
        uint256 actualCost = bingo.gameCost();
        
        // Then the returned cost should be 100 gwei
        assertEq(actualCost, EXPECTED_GAME_COST, "Game cost should be 100 gwei");
    }

    function testShouldJoinGameWhenEnoughFunds() public {
        address player = vm.addr(1); // Use anvil's default address
        hoax(player, 1 ether);
        bingo.joinGame{value: EXPECTED_GAME_COST}(); // Player attempts to join the game

        // Check if the player's balance decreased by the game cost
        assertEq(player.balance, 1 ether - EXPECTED_GAME_COST, "Player's balance should decrease by the game cost");

        // Check if the game's balance increased by the game cost
        assertEq(address(bingo).balance, EXPECTED_GAME_COST, "Game's balance should increase by the game cost");
    }
}