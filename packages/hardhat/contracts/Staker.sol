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

    event Stake(address, uint256);

    uint256 deadline = block.timestamp + 30 seconds;
    uint256 public constant threshold = 1 ether;

    // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
    //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )
    function stake() public payable {
        require(deadline < deadline + 30 seconds);
        balances[msg.sender] = msg.value;
        emit Stake(msg.sender, msg.value);
    }

    // After some `deadline` allow anyone to call an `execute()` function
    //  It should either call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value

    function execute() public {
        exampleExternalContract.complete{value: address(this).balance}();
    }

    // if the `threshold` was not met, allow everyone to call a `withdraw()` function

    function withdraw() public {
        //require(time.now > deadline);
        //this.send(msg.sender, balances[msg.sender]);
    }

    // Add a `withdraw(address payable)` function lets users withdraw their balance
    function timeLeft() public view returns (uint256) {
        return block.timestamp > deadline ? 0 : deadline - block.timestamp;
    }

    // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend

    function receive() public payable {
        //stake(msg.value);
    }

    // Add the `receive()` special function that receives eth and calls stake()
}
