// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {IBingo} from "./IBingo.sol";

contract Bingo {
    uint256 public constant GAME_COST = 100 gwei;

    constructor() {}

    function gameCost() public pure returns(uint256 gameCostWei) {
        gameCostWei = GAME_COST;
    }
}