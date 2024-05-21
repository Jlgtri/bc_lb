// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LockedFunds {
    event Deposit(uint128 amount);
    event Withdraw(uint128 amount);

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, 'Only owner can access this property.');
        _;
    }

    function getBalance() external view returns (uint128 balance) {
        return uint128(address(this).balance);
    }

    function deposit() external payable onlyOwner {
        require(msg.value > 0, 'Deposit amount must be greater than zero.');
        emit Deposit(uint128(msg.value));
    }

    function withdraw(uint128 amount) external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, 'Amount on the contract balance is zero.');
        require(
            balance >= amount,
            'Amount to withdraw is greater than contract balance.'
        );
        payable(owner).transfer(amount == 0 ? balance : amount);
        emit Withdraw(amount);
    }
}

contract CreditPlatform is LockedFunds {
    event InterestRateChange(uint16 amount);
    event MinimumAcquireAmountChange(uint64 amount);

    event Acquire(
        address indexed issuer,
        uint128 amount,
        uint32 duration,
        uint16 interestRate
    );
    event Settle(address indexed issuer, uint128 amount);
    event Default(address indexed recepient, string collateral);

    struct Loan {
        uint128 amount;
        uint32 expiresAt;
        uint32 previousSettleAt;
        uint16 interestRate;
    }

    constructor() LockedFunds() {
        setInterestRate(20_00);
        setMinimumAcquireAmount(0.001 ether);
    }

    uint32 public constant loanPeriod = 365 days;
    uint16 public constant interestRateRatio = 100_00;

    uint16 public interestRate;
    uint64 public minimumAcquireAmount;

    mapping(address => Loan) public activeLoans;
    mapping(address => string) internal collaterals;

    modifier notOwner() {
        require(msg.sender != owner, 'Owner can not access this property.');
        _;
    }

    function setInterestRate(uint16 rate) public onlyOwner {
        emit InterestRateChange(interestRate = rate);
    }

    function setMinimumAcquireAmount(uint64 amount) public onlyOwner {
        require(amount > 0, 'Acquire amount should be positive.');
        emit MinimumAcquireAmountChange(minimumAcquireAmount = amount);
    }

    function settleDefault(address recepient) external onlyOwner {
        Loan memory loan = activeLoans[recepient];
        require(
            loan.amount > 0,
            'The loan is already settled or non-existent!'
        );
        require(
            block.timestamp >= loan.expiresAt,
            'The loan can not be settled as default yet.'
        );

        emit Default(recepient, collaterals[recepient]);
        delete activeLoans[recepient];
        delete collaterals[recepient];
    }

    function getLoanAmount() public view notOwner returns (uint128 amount) {
        Loan memory loan = activeLoans[msg.sender];
        if (loan.amount == 0) {
            return 0;
        }

        uint32 timeDiff = uint32(block.timestamp) - loan.previousSettleAt;
        amount = loan.amount * loan.interestRate * timeDiff;
        amount /= loanPeriod;
        amount /= interestRateRatio;
        amount += loan.amount;
    }

    function acquire(
        uint128 amount,
        uint32 duration,
        string calldata collateral
    ) external notOwner {
        require(
            activeLoans[msg.sender].amount == 0,
            'There shoule be no active loan to settle!'
        );
        require(
            amount >= minimumAcquireAmount,
            'Acquire amount should be bigger than minimum amount.'
        );
        require(
            address(this).balance >= amount,
            'Current balance is smaller than acquiring amount.'
        );
        require(
            bytes(collateral).length > 0,
            'The collateral can not be empty.'
        );
        payable(msg.sender).transfer(amount);
        emit Acquire(msg.sender, amount, duration, interestRate);
        collaterals[msg.sender] = collateral;
        activeLoans[msg.sender] = Loan({
            amount: amount,
            expiresAt: uint32(block.timestamp + duration),
            previousSettleAt: uint32(block.timestamp),
            interestRate: interestRate
        });
    }

    function settle() external payable notOwner {
        require(
            activeLoans[msg.sender].amount > 0,
            'There is no active loan to settle.'
        );
        require(msg.value > 0, 'Settle value should be positive!');

        uint128 amount = getLoanAmount();
        Loan storage loan = activeLoans[msg.sender];
        loan.previousSettleAt = uint32(block.timestamp);
        if (msg.value > amount) {
            payable(msg.sender).transfer(msg.value - amount);
            emit Settle(msg.sender, amount);
            loan.amount = 0;
        } else {
            loan.amount = amount - uint128(msg.value);
            emit Settle(msg.sender, uint128(msg.value));
        }
        if (loan.amount == 0) {
            delete activeLoans[msg.sender];
            delete collaterals[msg.sender];
        }
    }
}
