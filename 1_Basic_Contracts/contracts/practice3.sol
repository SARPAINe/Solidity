// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Practise3 {
    address public owner;
    address[] public players;
    uint256 private a = 3;

    constructor() {
        owner = msg.sender;
    }

    function foo() external view returns (uint256) {
        uint256 b = a + 1;
        return b;
    }

    function enter() external {
        // require(msg.value>=1 ether);
        players.push(msg.sender);
    }

    function addNumbers(uint256[] calldata numbers)
        external
        view
        returns (uint256)
    {
        require(msg.sender == owner, "only owner can call this");
        uint256 sum = 0;
        for (uint256 i = 0; i < numbers.length; i++) sum += numbers[i];
        return sum + a;
    }

    function sortNumbers(uint256[] calldata numbers)
        external
        pure
        returns (uint256[] memory)
    {
        uint256[] memory tempArray = numbers;
        for (uint256 i = 0; i < tempArray.length; i++) {
            for (uint256 j = i + 1; j < tempArray.length; j++) {
                if (tempArray[i] >= tempArray[j]) {
                    uint256 tmp;
                    tmp = tempArray[i];
                    tempArray[i] = tempArray[j];
                    tempArray[j] = tmp;
                }
            }
        }
        // numbers=tempArray;
        return tempArray;
    }

    function stringLength(string calldata str) external pure returns (uint256) {
        return bytes(str).length;
    }

    function getTimestamp() public view returns (uint256) {
        return block.timestamp;
    }
}
