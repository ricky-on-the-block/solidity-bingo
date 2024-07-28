// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {IBingo} from "./IBingo.sol";

contract Bingo {
    uint256 public constant GAME_COST = 100 gwei;
    uint256 public constant NUM_PLAYERS = 5;

    constructor() {}

    function gameCost() public pure returns(uint256 gameCostWei) {
        gameCostWei = GAME_COST;
    }

    function joinGame() external payable {
        require(msg.value >= GAME_COST, "Insufficient funds to join the game");
    }
}