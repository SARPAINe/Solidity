// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Mappings {
    mapping(address => uint256) balances;
    //nested mapping
    mapping(address => mapping(address => bool)) approved;
    //array inside mapping
    mapping(address => uint256[]) scores;
    mapping(address => uint256) count;

    function invest() external payable {
        //add element
        balances[msg.sender] += msg.value;
        count[msg.sender] += 1;
        //read
        //balances[msg.sender];
        //update
        //balances[msg.sender]=200;
        // delete
        // delete balances[msg.sender];
        //default values
        //every key is accessible even if it doesn't exist, default value for uint 0,
        //bool =false
        if (count[msg.sender] == 1) scores[msg.sender].push(1);
        else
            scores[msg.sender].push(
                scores[msg.sender][count[msg.sender] - 2] + 1
            );
    }

    function checkScore(address tmp) public view returns (uint256[] memory) {
        return scores[tmp];
    }

    function getBalances(address tmp) external view returns (uint256) {
        return balances[tmp];
    }
}
