// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract SeventhCaller {
    uint256 public seventhCaller = 7 ether;
    address public winner;

    //need to create a balance state variable to prevent forcefully sending ether
    uint256 public increment;

    function deposit() public payable {
        require(msg.value == 1 ether, "You can only send 1 Ether");

        increment += msg.value;
        require(increment <= seventhCaller, "Game is over");

        //if the counter is 7, they're the winner
        if (increment == seventhCaller) {
            winner = msg.sender;
        }
    }

    function claimReward() public {
        require(msg.sender == winner, "Not winner");

        //this will send all the ether in this contract to the winner
        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}