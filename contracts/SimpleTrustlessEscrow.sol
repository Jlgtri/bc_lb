pragma solidity ^0.8.0;

// Базовий шаблон смарт-контракту
contract SimpleTrustlessEscrow {
    // Змінні стану
    address public depositor; // адреса вкладника, що поповнює рахунок
    address payable public beneficiary; // Рахунок, який отримує ефір
    uint256 public releaseTime; // Тимчасова мітка для випуску ефіру
    // Події для перевірки активності контракту
    event Deposited(address indexed _from, uint256 _value);
    event Released(address indexed _to, uint256 _value);

    // Конструктор контракту инициализирует смарт-контракт
    constructor(address payable _beneficiary, uint256 _releaseIn) {
        // Безпечний і надійний: Контракт з’язує вкладника та бенефіціара
        depositor = msg.sender;
        beneficiary = _beneficiary;
        releaseTime = block.timestamp + _releaseIn;
    }

    // Функція депозиту – автономне виконання (fallback функція)
    receive() external payable {
        emit Deposited(msg.sender, msg.value);
    }

    // Відпустіть ефір бенефіціару
    function release() public {
        // Програмований: може бути виконано лише після releaseTime
        require(block.timestamp >= releaseTime, 'Too early to release');
        // Автономний: автоматично виконується на основі умови
        uint256 amount = address(this).balance;
        beneficiary.transfer(amount);
        emit Released(beneficiary, amount);
    }

    function getBalance() external view returns (uint256 balance) {
        return address(this).balance;
    }
}
