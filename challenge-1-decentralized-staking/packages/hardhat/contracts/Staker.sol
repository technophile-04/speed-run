// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

error Staker__LessThanThreshold();
error Staker__DeadlineNotMet();
error Staker__NoEnoughBalanceToWithdraw();
error Staker__AlreadyStaked();

contract Staker {
    /* Events  */
    event Stake(address staker, uint256 value);

    /* State varaibles */
    mapping(address => uint256) public balances;
    ExampleExternalContract public exampleExternalContract;
    bool public openToWithdraw = true;

    /* Constants / Immutables*/
    uint256 public constant THRESHOLD = 1 ether;
    uint256 public immutable deadline;

    /* modifiers */
    modifier isMinimumThreshold() {
        if (address(this).balance < THRESHOLD) {
            openToWithdraw = true;
            revert Staker__LessThanThreshold();
        }
        _;
    }

    modifier isDeadlineComplete() {
        if (block.timestamp < deadline) {
            revert Staker__DeadlineNotMet();
        }
        openToWithdraw = false;
        _;
    }

    modifier notCompleted() {
        if (exampleExternalContract.completed()) {
            revert Staker__AlreadyStaked();
        }
        _;
    }

    constructor(address exampleExternalContractAddress) {
        exampleExternalContract = ExampleExternalContract(
            exampleExternalContractAddress
        );
        deadline = block.timestamp + 72 hours;
    }

    receive() external payable {
        stake();
    }

    /* Functions */
    function stake() public payable notCompleted {
        balances[msg.sender] += msg.value;
        emit Stake(msg.sender, msg.value);
    }

    function execute() public isDeadlineComplete notCompleted {
        if (address(this).balance < THRESHOLD) {
            return;
        }
        exampleExternalContract.complete{value: address(this).balance}();
    }

    function withdraw() public {
        require(address(this).balance < THRESHOLD, "Threshold completed");
        // if (balances[msg.sender] > 0) {
        //     revert Staker__NoEnoughBalanceToWithdraw();
        // }

        uint256 valueToWithdraw = balances[msg.sender];
        (bool success, ) = address(msg.sender).call{value: valueToWithdraw}("");

        require(success, "Withdrawal failed");
    }

    function timeLeft() public view returns (uint256) {
        if (block.timestamp >= deadline) {
            return 0;
        }

        return deadline - block.timestamp;
    }
}
