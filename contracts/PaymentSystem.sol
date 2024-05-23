// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PaymentSystem {
    mapping(address => uint256) private balances;

    // Подія для логування транзакцій
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Функція для внесення коштів на рахунок користувача
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Функція для переведення коштів іншому користувачеві
    function transfer(address to, uint256 amount) public {
        require(to != address(0), 'Invalid address');
        require(amount <= balances[msg.sender], 'Insufficient balance');

        balances[msg.sender] -= amount;
        balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }

    // Функція для перевірки балансу користувача
    function getBalance(address user) public view returns (uint256) {
        return balances[user];
    }
}
