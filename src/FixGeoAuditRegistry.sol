// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * @title FixGeoAuditRegistry
 * @notice On-chain RAG freshness & subscription oracle for FixGEO directories
 *         with enterprise Role-Based Access Control (RBAC).
 */
contract FixGeoAuditRegistry is AccessControl {
    // Role identifier for authorized auditors
    bytes32 public constant AUDITOR_ROLE = keccak256("AUDITOR_ROLE");

    struct CompanySubscription {
        uint256 companyId;
        string companyName;
        string directoryTag;     // e.g., "TUMAPAIA", "LISTADOMOS", "VASTFUNNEL"
        uint16 visibilityScore;   // e.g., 680 = 68.0 / 100
        uint256 validUntil;       // Unix timestamp when monthly audit expires
        string ragManifestHash;   // IPFS hash containing current llms.txt & JSON-LD
        bool isFreeAuditCompleted;
    }

    // Mapping: companyId => CompanySubscription
    mapping(uint256 => CompanySubscription) public subscriptions;

    event FreeAuditCompleted(uint256 indexed companyId, string companyName, uint16 visibilityScore);
    event SubscriptionRenewed(uint256 indexed companyId, uint256 newValidUntil, string newRAGHash);

    constructor() {
        // The deployer gets full admin privileges
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        // The deployer is also granted the auditor role
        _grantRole(AUDITOR_ROLE, msg.sender);
    }

    /**
     * @notice Step 1: Record the free initial audit score
     * @dev Restricted to addresses with AUDITOR_ROLE
     */
    function recordFreeAudit(
        uint256 companyId,
        string calldata companyName,
        string calldata directoryTag,
        uint16 visibilityScore
    ) external onlyRole(AUDITOR_ROLE) {
        subscriptions[companyId] = CompanySubscription({
            companyId: companyId,
            companyName: companyName,
            directoryTag: directoryTag,
            visibilityScore: visibilityScore,
            validUntil: 0, // Unsubscribed initially until monthly retainer starts
            ragManifestHash: "",
            isFreeAuditCompleted: true
        });

        emit FreeAuditCompleted(companyId, companyName, visibilityScore);
    }

    /**
     * @notice Step 2: Activate or renew the monthly subscription retainer with updated RAG manifest
     * @dev Restricted to addresses with AUDITOR_ROLE
     */
    function renewMonthlySubscription(
        uint256 companyId,
        uint256 durationInDays,
        uint16 updatedScore,
        string calldata newRAGHash
    ) external onlyRole(AUDITOR_ROLE) {
        require(subscriptions[companyId].isFreeAuditCompleted, "FixGEO: Complete free audit first");

        CompanySubscription storage sub = subscriptions[companyId];
        
        uint256 baseTime = sub.validUntil > block.timestamp ? sub.validUntil : block.timestamp;
        sub.validUntil = baseTime + (durationInDays * 1 days);
        sub.visibilityScore = updatedScore;
        sub.ragManifestHash = newRAGHash;

        emit SubscriptionRenewed(companyId, sub.validUntil, newRAGHash);
    }

    /**
     * @notice Public view function for AI Agents (MCP) & RAG Retrievers
     */
    function isRAGActive(uint256 companyId) external view returns (bool active, uint16 score, string memory ragHash) {
        CompanySubscription memory sub = subscriptions[companyId];
        bool isActive = (sub.isFreeAuditCompleted && sub.validUntil > 0 && block.timestamp <= sub.validUntil);
        return (isActive, sub.visibilityScore, sub.ragManifestHash);
    }
}