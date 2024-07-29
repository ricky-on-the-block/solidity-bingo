// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {IBingo} from "./IBingo.sol";

contract Bingo {
    uint256 public constant GAME_COST = 100 gwei;
    uint256 public constant PLAYER_CAP = 5;
    uint256 public numPlayers;

    struct Board {
        uint8[5] bCol;
        uint8[5] iCol;
        uint8[5] nCol;
        uint8[5] gCol;
        uint8[5] oCol;
    }

    mapping(address => Board) playerBoards;

    constructor() {}

    function gameCost() public pure returns (uint256 gameCostWei) {
        gameCostWei = GAME_COST;
    }

    function joinGame() external payable {
        require(msg.value >= GAME_COST, "Insufficient funds to join the game");
        uint256 _numPlayers = numPlayers;
        require(_numPlayers < PLAYER_CAP, "Game is full");
        numPlayers = _numPlayers + 1;

        generateBoard(msg.sender);
    }

    function boards(address player) public view returns (Board memory) {
        return playerBoards[player];
    }

    /**
     * @notice Generates a unique bingo board for a player
     * @dev The board is represented as an array of 25 uint8 values, where each value corresponds to a cell on the board
     * @dev The values are arranged as follows:
     *      - 0-4 represent the 'B' column (values 1-15)
     *      - 5-9 represent the 'I' column (values 16-30)
     *      - 10-14 represent the 'N' column (values 31-45)
     *      - 15-19 represent the 'G' column (values 46-60)
     *      - 20-24 represent the 'O' column (values 61-75)
     * @param player The address of the player for whom the board is being generated
     * @return board The generated bingo board
     */
    function generateBoard(address player) internal returns (Board memory) {
        Board memory board = boards(player);
        board.bCol = generateColumn(1);
        board.iCol = generateColumn(2);
        board.nCol = generateColumn(3);
        board.gCol = generateColumn(4);
        board.oCol = generateColumn(5);
        playerBoards[player] = board;
        return board;
    }

/**
* @notice Generates a random column for the bingo board using the Fisher-Yates shuffle algorithm
* @dev The Fisher-Yates shuffle is an efficient algorithm for generating a random permutation of a finite set
* @dev It is more efficient than using a mapping or bitpacking approach, as it avoids the need for additional storage or complex bit operations
* @dev The algorithm works by iterating through the set of elements and swapping each element with a randomly chosen element from the remaining unshuffled elements
* @param columnOffset The offset value used to generate the correct range of values for the column (e.g., 1 for 'B' column, 2 for 'I' column, etc.)
* @return column An array of 5 random values representing the column of the bingo board
*/
    function generateColumn(uint256 columnOffset) internal view returns (uint8[5] memory column) {
        uint8[15] memory fisherYates = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

        // Perform Fisher-Yates shuffle for the first 5 elements
        for (uint8 i = 0; i < 5; i++) {
            uint8 j = i + (rng() % (15 - i));
            (fisherYates[i], fisherYates[j]) = (fisherYates[j], fisherYates[i]);
            column[i] = uint8(fisherYates[i] * columnOffset);
        }

        return column;
    }

    // Mock a fake RNG for testing purposes
    function rng() internal view returns (uint8) {
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))));
    }
}
