pragma solidity 0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
    ExampleExternalContract public exampleExternalContract;

    constructor(address exampleExternalContractAddress) public {
        exampleExternalContract = ExampleExternalContract(
            exampleExternalContractAddress
        );
    }

    mapping(address => uint256) public balances;

    event Stake(address sender, uint256 amount);

    uint256 deadline = block.timestamp + 30 seconds;
    uint256 public constant threshold = 1 ether;
    bool private openForWithdraw = false;

    // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
    //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
    function stake() public payable {
        require(block.timestamp + 30 seconds > deadline);
        balances[msg.sender] = msg.value;
        emit Stake(msg.sender, msg.value);
    }

    // After some `deadline` allow anyone to call an `execute()` function
    //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value

    function execute() public {
        require(block.timestamp + 30 seconds > deadline);
        require(
            address(this).balance >= 1 ether,
            "Eth balance must be at least 1 Eth"
        );
        exampleExternalContract.complete{value: address(this).balance}();
    }

    // if the `threshold` was not met, allow everyone to call a `withdraw()` function

    function withdraw(address payable _to) public {
        uint256 withdrawalAmount = balances[msg.sender];
        require(withdrawalAmount > 0, "Not enough balance");
        balances[msg.sender] = 0;
        (bool sent, ) = _to.call{value: withdrawalAmount}("");
        require(sent, "failed to send balance");
    }

    // Add a `withdraw(address payable)` function lets users withdraw their balance
    function timeLeft() public view returns (uint256) {
        return block.timestamp > deadline ? 0 : deadline - block.timestamp;
    }

    // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend

    function receive() external payable {
        stake();
    }

    // Add the `receive()` special function that receives eth and calls stake()
}
