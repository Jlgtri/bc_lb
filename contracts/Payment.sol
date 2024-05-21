pragma solidity ^0.8.0;

contract Payment {
    uint256 public transactionCount = 0;
    uint256 public transactionAmount = 0;

    function getBalance() public view returns (uint256) {
        return msg.sender.balance;
    }

    function payBill(address payable account) public payable {
        require(msg.sender.balance >= msg.value, 'Not enough funds!');
        transactionCount++;
        transactionAmount += msg.value;
        account.transfer(msg.value);
    }
}
