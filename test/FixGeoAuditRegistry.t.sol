// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/FixGeoAuditRegistry.sol";

contract FixGeoAuditRegistryTest is Test {
    FixGeoAuditRegistry public registry;
    address public admin = address(this);
    address public assistantAuditor = address(0x123);
    address public unauthorizedHacker = address(0x999);

    function setUp() public {
        registry = new FixGeoAuditRegistry();
    }

    function test_FreeAuditAndMonthlyRenewal() public {
        registry.recordFreeAudit(101, "Taranis", "TUMAPAIA", 680);

        (bool activeBefore, , ) = registry.isRAGActive(101);
        assertFalse(activeBefore);

        registry.renewMonthlySubscription(101, 30, 720, "QmHashTaranisRAGManifest123");

        (bool activeAfter, uint16 score, string memory ragHash) = registry.isRAGActive(101);
        assertTrue(activeAfter);
        assertEq(score, 720);
        assertEq(ragHash, "QmHashTaranisRAGManifest123");
    }

    function test_SubscriptionExpiration() public {
        registry.recordFreeAudit(102, "Agentic Consulting", "VASTFUNNEL", 600);
        registry.renewMonthlySubscription(102, 30, 600, "QmHashAgenticConsulting");

        vm.warp(block.timestamp + 31 days);

        (bool active, , ) = registry.isRAGActive(102);
        assertFalse(active);
    }

    function test_RevertWhen_UnauthorizedRecordsAudit() public {
        vm.prank(unauthorizedHacker);
        vm.expectRevert();
        registry.recordFreeAudit(103, "Carbon Robotics", "TUMAPAIA", 412);
    }

    function test_AdminCanGrantAuditorRole() public {
        bytes32 auditorRole = registry.AUDITOR_ROLE();
        registry.grantRole(auditorRole, assistantAuditor);

        vm.prank(assistantAuditor);
        registry.recordFreeAudit(103, "Carbon Robotics", "TUMAPAIA", 412);

        (uint256 id, string memory name, , , , , bool completed) = registry.subscriptions(103);
        assertEq(id, 103);
        assertEq(name, "Carbon Robotics");
        assertTrue(completed);
    }

    /// @dev Fuzz Test: Foundry attacks this with 256 random IDs and scores automatically
    function testFuzz_RecordFreeAudit(uint256 randomCompanyId, uint16 randomScore) public {
        registry.recordFreeAudit(randomCompanyId, "Fuzzed Company", "TUMAPAIA", randomScore);

        (uint256 id, string memory name, , uint16 score, , , bool completed) = registry.subscriptions(randomCompanyId);

        assertEq(id, randomCompanyId);
        assertEq(name, "Fuzzed Company");
        assertEq(score, randomScore);
        assertTrue(completed);
    }
}