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

    function testGameCost() public view {
        // Given the game cost is set to 100 gwei
        // When we call getGameCost
        uint256 actualCost = bingo.gameCost();
        
        // Then the returned cost should be 100 gwei
        assertEq(actualCost, EXPECTED_GAME_COST, "Game cost should be 100 gwei");
    }

    function testRevertWhenJoiningFullGame() public {
        // Setup: Fill the game with the maximum number of players
        for (uint i = 1; i < 6; i++) {
            hoax(vm.addr(i), 1 ether); // Impersonate different players
            bingo.joinGame{value: EXPECTED_GAME_COST}();
        }

        // Test: Attempt to join the game with one more player
        address extraPlayer = vm.addr(6);
        hoax(extraPlayer, 1 ether);
        
        // Expectation: This should fail as the game is already full
        vm.expectRevert();
        bingo.joinGame{value: EXPECTED_GAME_COST}();
    }

    function testGameCollectsCostFromPlayerOnJoining() public {
        address player = vm.addr(1); // Use anvil's default address
        hoax(player, 1 ether);
        bingo.joinGame{value: EXPECTED_GAME_COST}(); // Player attempts to join the game

        // Check if the player's balance decreased by the game cost
        assertEq(player.balance, 1 ether - EXPECTED_GAME_COST, "Player's balance should decrease by the game cost");

        // Check if the game's balance increased by the game cost
        assertEq(address(bingo).balance, EXPECTED_GAME_COST, "Game's balance should increase by the game cost");
    }

    function testBingoBoardGeneratedWhenPlayerJoins() public {
        // Given a player has joined the game
        address player = vm.addr(1);
        hoax(player, 1 ether);
        bingo.joinGame{value: EXPECTED_GAME_COST}();

        // Then the player should receive a unique bingo board
        uint8[25] memory playerBoard = bingo.boards(player);
        bool hasZeroElement = false;
        for (uint8 i = 0; i < playerBoard.length; i++) {
            if (playerBoard[i] == 0) {
                hasZeroElement = true;
                break;
            }
        }
        assertFalse(hasZeroElement, "Player board should not have any zero elements");
    }
}