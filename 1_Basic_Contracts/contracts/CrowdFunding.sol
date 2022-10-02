// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract CampaignFactory {
    address[] public deployedCampaigns;

    event CampaignCreated(
        address indexed manager,
        address campgaignAddress,
        string campaignName
    );

    function createCampaign(
        string calldata campaignName,
        string calldata campaignDescription,
        uint256 minimumAmount,
        uint256 goalAmount
    ) public {
        Campaign newCampaign = new Campaign(
            campaignName,
            campaignDescription,
            minimumAmount,
            goalAmount,
            msg.sender
        );
        emit CampaignCreated(msg.sender, address(newCampaign), campaignName);
        deployedCampaigns.push(address(newCampaign));
    }

    function getDeployedCampaigns() public view returns (address[] memory) {
        return deployedCampaigns;
    }
}

contract Campaign {
    struct Request {
        string description;
        uint256 value;
        address recipient;
        bool complete;
        uint256 approvalCount;
        mapping(address => bool) approvals;
    }

    Request[] public requests;
    string public name;
    string public description;
    uint256 private numberOfRequests;
    address public manager;
    uint256 public minimumContribution;
    uint256 public collectionGoal;
    mapping(address => bool) public approvers;
    uint256 public approversCount;

    event RequestCreated(
        address indexed recipient,
        string description,
        uint256 value
    );

    modifier restricted() {
        require(msg.sender == manager, "Only Campaign owner can do this!");
        _;
    }

    constructor(
        string memory campaignName,
        string memory campaignDescription,
        uint256 minimum,
        uint256 goal,
        address creator
    ) {
        manager = creator;
        name = campaignName;
        description = campaignDescription;
        minimumContribution = minimum;
        collectionGoal = goal;
    }

    function contribute() public payable {
        require(
            msg.value >= minimumContribution,
            "Minimum contribution is not met!"
        );
        if (approvers[msg.sender] == false) approversCount++;
        approvers[msg.sender] = true;
    }

    function requestFundWithdraw(
        string calldata _description,
        uint256 _value,
        address _recipient
    ) public restricted {
        Request storage newRequest = requests.push();
        newRequest.description = _description;
        newRequest.value = _value;
        newRequest.recipient = _recipient;
        newRequest.complete = false;
        newRequest.approvalCount = 0;
        emit RequestCreated(_recipient, _description, _value);
        //need to add event
    }

    function approveRequest(uint256 index) public {
        Request storage request = requests[index];

        require(
            approvers[msg.sender],
            "Only a contributor to this Campaign can approve a request!"
        );
        require(
            !request.approvals[msg.sender],
            "This contributor already approved the request once!"
        );

        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }

    function disburseFund(uint256 index) public restricted {
        Request storage request = requests[index];

        require(
            request.approvalCount > (approversCount / 2),
            "More than 50% contributors didn't approve the request yet!" //works
        );
        require(!request.complete, "Request already finalized!"); //works

        address payable wallet = payable(address(request.recipient));
        // request.recipient.transfer(request.value);
        wallet.transfer(request.value);
        request.complete = true;
    }

    function getSummary()
        public
        view
        returns (
            string memory,
            string memory,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            address
        )
    {
        return (
            name,
            description,
            minimumContribution,
            collectionGoal,
            address(this).balance,
            requests.length,
            approversCount,
            manager
        );
    }

    function getRequestCount() public view returns (uint256) {
        return requests.length;
    }
}
