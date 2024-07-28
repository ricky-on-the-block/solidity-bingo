// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

interface IBingo {
    function gameCost() external view returns (uint256 costWei);
}