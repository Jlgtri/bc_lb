// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Counter {
    int256 private count = 0;

    function incrementCounter() public {
        count++;
    }

    function decrementCounter() public {
        count--;
    }

    function getCount() public view returns (int256) {
        return count;
    }
}
