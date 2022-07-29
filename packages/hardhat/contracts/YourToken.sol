pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// learn more: https://docs.openzeppelin.com/contracts/3.x/erc20

contract YourToken is ERC20 {
    uint256 private constant TOTAL_SUPPLY = 1000 * (10**18);

    constructor() ERC20("Gold", "GLD") {
        _mint(msg.sender, TOTAL_SUPPLY);
    }
}