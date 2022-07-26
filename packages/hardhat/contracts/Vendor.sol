pragma solidity 0.8.4;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);

    event TokensSell(
        address seller,
        uint256 amountOfTokens,
        uint256 amountOfEth
    );

    uint256 public constant tokensPerEth = 100;

    YourToken public yourToken;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    function buyTokens() public payable {
        uint256 numberOfTokens = tokensPerEth * msg.value;

        yourToken.transfer(msg.sender, numberOfTokens);

        emit BuyTokens(msg.sender, msg.value, numberOfTokens);
    }

    function withdraw() public onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");

        require(success, "Transfer of eth failed to owner");
    }

    function sellTokens(uint256 _amount) public {
        yourToken.transferFrom(msg.sender, address(this), _amount);

        uint256 buyBackPrice = _amount / tokensPerEth;

        (bool success, ) = payable(msg.sender).call{value: buyBackPrice}("");

        require(success, "Transfer of eth failed");

        emit TokensSell(msg.sender, _amount, buyBackPrice);
    }
}
