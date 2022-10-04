// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract A{
    mapping(address=>uint256) public balance;
    function withdraw() external payable{
        if(balance[msg.sender]>0){
        address payable to=payable(msg.sender);
        bool sent=to.send(balance[msg.sender]);
        require(sent,"Transfer Failed!");
        }
    }

    function withdrawWithoutData(address payable _to, uint256 _amount) external payable{
        bool sent=_to.send(_amount);
        require(sent,"Transfer Failed!");
    }

    function withdrawWithData(address payable _to, uint256 _amount) external payable{
        bool sent=_to.send(_amount);
        balance[_to]+=_amount;
        require(sent,"Transfer Failed!");
    }

    function withdrawFromValue(address payable _to) external payable{
        // bool sent=_to.send(msg.value);
        bool sent=_to.send(msg.value);
        require(sent,"Transfer Failed :(");
    }

    //msg.data must be empty
    function transferViaCall1(address _b) public returns(bool){
        (bool success,bytes memory data) = address(_b).call{value: 200 wei}("");
        require(success);
        return true;
    }

    //fallback function will be called if msg.data is not-empty
    function transferViaCall2(address _b) public returns(bool){
        (bool success,bytes memory data) = address(_b).call{value: 200 wei}("hukka");
        require(success);
        return true;
    }

    function setBalance(address _to,uint256 _value) external {
        balance[_to]=_value;
    }
    
    function checkBalance() external view returns(uint256){
        return address(this).balance;
    }

    receive() external payable {}
}

contract B{
    mapping(address=>uint256) public balance;
    address public sender1;
    address public sender2;

    // Function to receive Ether. msg.data must be empty
    receive() external payable {
        sender1=msg.sender;
    }
    //this is called if there is data on the transaction
    fallback() external payable{
        sender2=msg.sender;
    }
     function checkBalance() external view returns(uint256){
        return address(this).balance;
    }
}