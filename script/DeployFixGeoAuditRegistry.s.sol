// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/FixGeoAuditRegistry.sol";

contract DeployFixGeoAuditRegistry is Script {
    function run() external returns (FixGeoAuditRegistry) {
        vm.startBroadcast();

        FixGeoAuditRegistry registry = new FixGeoAuditRegistry();

        vm.stopBroadcast();
        return registry;
    }
}