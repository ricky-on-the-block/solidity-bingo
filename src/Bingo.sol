// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {IBingo} from "./IBingo.sol";

contract Bingo {
    uint256 public constant GAME_COST = 100 gwei;
    uint256 public constant PLAYER_CAP = 5;
    uint256 public numPlayers;

    mapping(address => uint8[25]) playerBoards;

    constructor() {}

    function gameCost() public pure returns(uint256 gameCostWei) {
        gameCostWei = GAME_COST;
    }

    function joinGame() external payable {
        require(msg.value >= GAME_COST, "Insufficient funds to join the game");
        uint256 _numPlayers = numPlayers;
        require(_numPlayers < PLAYER_CAP, "Game is full");
        numPlayers = _numPlayers + 1;
    }

    function boards(address player) external view returns(uint8[25] memory board){
        board = playerBoards[player];
    }
}