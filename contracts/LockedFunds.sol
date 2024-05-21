// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LockedFunds {
    address public owner;
    uint256 public lockTime;
    uint256 amount;
    address[] investors;
    mapping(address => uint256) public deposits;

    event LogDeposit(address indexed sender, uint256 amount);
    event LogWithdrawal(address indexed sender, uint256 amount);

    constructor(uint256 _lockTime) {
        owner = msg.sender;
        // на скільки заморожуватимуться кошти
        lockTime = block.timestamp + _lockTime;
    }

    // приймає гроші
    function deposit() external payable {
        require(msg.value > 0, 'Deposit amount must be greater than zero.');
        deposits[owner] += msg.value;
        deposits[msg.sender] += msg.value;
        investors.push(msg.sender);
        emit LogDeposit(msg.sender, msg.value);
    }

    // знімає гроші з контракту
    function withdraw() external {
        require(msg.sender == owner, 'Only the contract owner can withdraw.');
        require(
            block.timestamp >= lockTime,
            'Funds are locked and cannot be withdrawn yet.'
        );
        amount = address(this).balance;
        require(amount > 0, 'amount deposit = 0');
        payable(owner).transfer(amount);
        deposits[owner] -= amount;
        uint256 quantity = investors.length;
        for (uint256 i = 0; i < investors.length; i++) {
            deposits[investors[i]] = 0;
        }
        for (uint256 i = 0; i < quantity; i++) {
            investors.pop();
        }
        emit LogWithdrawal(msg.sender, amount);
    }

    // повертає суму депозиту
    function getDeposit(address account) external view returns (uint256) {
        return deposits[account];
    }

    // повертає баланс аккаунта з адресою account
    function getBalanceAccount(
        address account
    ) external view returns (uint256) {
        return account.balance;
    }

    function getTimestamp() external view returns (uint256) {
        return block.timestamp;
    }
}
