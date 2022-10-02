// // SPDX-License-Identifier: MIT
// pragma solidity >=0.4.22 <0.9.0;

// contract Exam {
//     address public owner;
//     address[] public players;

//     constructor() {
//         owner = msg.sender;
//     }

//     function() external payable {}

//     function enter() public payable {
//         require(msg.value >= 1 ether);
//         players.push(msg.sender);
//     }

//     function getSize() public view returns (uint256) {
//         return players.length;
//     }

//     function getAddress() public view returns (address) {
//         return address(this);
//     }

//     function random() public view returns (uint256) {
//         return uint256(keccak256(block.difficulty, now, players));
//     }

//     function pickWinner() public onlyOwner {
//         uint256 index = random() % getSize();
//         players[index].transfer(address(this).balance);
//     }

//     function sendMoney(address reciever) public payable {
//         if (msg.sender.balance >= msg.value) reciever.transfer(msg.value);
//         else reciever.transfer(msg.sender.balance);
//     }

//     modifier onlyOwner() {
//         require(msg.sender == owner);
//         _;
//     }
// }
