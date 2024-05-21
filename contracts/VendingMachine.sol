// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
contract VendingMachine {
    // Оголошення змінних стану контракту
    address public owner;
    mapping(address => uint) public cupcakeBalances;
    // Коли розгорнуть контракт "VendingMachine":
    // 1. встановлює адресу розгортання як власника договору
    // 2. встановлює кекс-баланс розгорнутого смарт-контракту на 100
    constructor() {
        owner = msg.sender;
        cupcakeBalances[owner] = 100;
    }
    // Дозволяє власнику збільшувати кексовий баланс смарт-контракту
    function refill(uint amount) public {
        require(msg.sender == owner, 'Only the owner can refill.');
        cupcakeBalances[msg.sender] += amount;
    }
    // Дозволяє будь-кому придбати кекси
    function purchase(uint amount) public payable {
        require(
            cupcakeBalances[owner] >= amount,
            'Not enough cupcakes in stock to complete this purchase'
        );
        require(
            msg.value == amount * 0.01 ether,
            'You must pay exactly 0.01 ETH per cupcake'
        );
        cupcakeBalances[owner] -= amount;
        cupcakeBalances[msg.sender] += amount;
    }
}
