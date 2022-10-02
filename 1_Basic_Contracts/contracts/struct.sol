// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract Struct {
    struct User {
        address addr;
        uint256 donation;
        string name;
    }

    User[] users;

    // function enter(string calldata name) external payable{
    //     require(msg.value>0.5 ether);
    //     User memory user1=User(msg.sender,msg.value,name);
    //     users.push(user1);
    // }
    // function getUser() external view returns(User memory){
    //     User memory tempUser=users[0];
    //     return tempUser;
    // }
    mapping(address => User) userList;

    function enter(string calldata name) external payable {
        require(msg.value > 0.5 ether);
        User memory user1 = User(msg.sender, msg.value, name);
        userList[msg.sender] = user1;
    }

    function getUser(address addr) external view returns (User memory) {
        return userList[addr];
    }
}
