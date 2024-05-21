pragma solidity ^0.8.0;

struct Candidate {
    uint256 id;
    string lastName;
    string name;
    string patronymic;
    string info;
    uint256 voteCount;
}

contract Election {
    constructor() public {
        addCandidate('Bondarenko', 'Bogdan', 'Bogdanovich', 'GoodLife');
        addCandidate('Kovalenko', 'Petro', 'Petrovich', 'Green');
        addCandidate('Shevchenko', 'Taras', 'Tarasovich', 'BP');
    }

    // Зберігання виборців, які проголосували
    mapping(address => bool) public voters;
    // Зберігання кандидатів
    mapping(uint256 => Candidate) public candidates;
    // Кількість кандидатів
    uint256 public candidatesCount;

    function addCandidate(
        string memory _lastName,
        string memory _name,
        string memory _patronymic,
        string memory info
    ) public {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(
            candidatesCount,
            _lastName,
            _name,
            _patronymic,
            info,
            0
        );
    }

    function vote(uint256 _candidateId) public {
        // Перевірка, чи не голосував виборець раніше
        require(!voters[msg.sender]);
        // Перевірка чи є такий кандидат
        require(_candidateId > 0 && _candidateId <= candidatesCount);
        // Відмічаємо, що цей виборець вже голосував
        voters[msg.sender] = true;
        // Додаємо голос за обраного кандидата
        candidates[_candidateId].voteCount++;
    }

    function winningProposal() public view returns (uint256 winning) {
        uint256 winningVoteCount = 0;
        for (
            uint256 candidate = 1;
            candidate <= candidatesCount;
            candidate++
        ) {
            uint256 voteCount = candidates[candidate].voteCount;
            if (voteCount > winningVoteCount) {
                winningVoteCount = voteCount;
                winning = candidate;
            }
        }
    }
}
