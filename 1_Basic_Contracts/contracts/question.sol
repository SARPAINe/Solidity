// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract QuestionFactory {
    address[] public deployedQuestions;
    mapping(address => bool) public postedQuestion;

    function createQuestion(
        string calldata _questionTitle,
        string calldata _questionBody,
        uint256 _reward
    ) public {
        // postNotClosed[0x5B38Da6a701c568545dCfcB03FcB875f56beddC4]=true;
        require(
            !postedQuestion[msg.sender],
            "User have unresolved question! User should close question"
        );
        Question newQuestion = new Question(
            _questionTitle,
            _questionBody,
            _reward,
            msg.sender,
            address(this)
        );
        deployedQuestions.push(address(newQuestion));
        postedQuestion[msg.sender] = true;
    }

    function updateData(address user, bool a) public {
        postedQuestion[user] = a;
    }

    function getDeployedQuestions() public view returns (address[] memory) {
        return deployedQuestions;
    }
}

contract Question {
    string public questionBody;
    string public questionTitle;
    address public questionOwner;
    address public factoryAddress;
    uint256 public reward;
    bool public closed;
    uint256 public winner;
    bool public answerSelected;

    struct Answer {
        address answerOwner;
        string solution;
    }
    Answer[] public answers;

    constructor(
        string memory _questionTitle,
        string memory _questionBody,
        uint256 _reward,
        address creator,
        address _factoryAddress
    ) public {
        questionTitle = _questionTitle;
        questionBody = _questionBody;
        questionOwner = creator;
        reward = _reward;
        factoryAddress = _factoryAddress;
    }

    function createAnswer(string calldata answer) public {
        Answer memory newAnswer = Answer({
            answerOwner: msg.sender,
            solution: answer
        });

        answers.push(newAnswer);
    }

    modifier restricted() {
        require(
            msg.sender == questionOwner,
            "Only question owner has the authority"
        );
        _;
    }

    function chooseAnswer(uint256 index) public restricted {
        require(
            answers[index].answerOwner != msg.sender,
            "You can't choose your own comment as answer!"
        );
        winner = index;
        answerSelected = true;
    }

    function sendReward() public payable restricted {
        require(answerSelected = true, "First select a answer to send reward!");
        require(
            msg.value >= reward * 1 wei,
            "Reward should be greater than the least amount!"
        );

        address payable wallet = payable(address(answers[winner].answerOwner));
        // request.recipient.transfer(request.value);
        wallet.transfer(msg.value);
        closed = true;
    }

    function closeQuestion() public restricted {
        require(
            (closed == true || answers.length == 0),
            "You can close the question only after you have sent reward! or if there is no posted answer"
        );
        QuestionFactory questionFactory = QuestionFactory(factoryAddress);
        questionFactory.updateData(msg.sender, false);
    }

    function getAnswerCount() public view returns (uint256) {
        return answers.length;
    }
}
