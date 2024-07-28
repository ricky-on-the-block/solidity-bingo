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
}