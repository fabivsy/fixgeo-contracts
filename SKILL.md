---
name: fixgeo-onchain-trust
description: Production reference for FixGeoAuditRegistry smart contract on Ethereum Sepolia, on-chain provenance, verification badges, and AI agent procurement.
---

# FixGEO On-Chain Trust & Audit Registry Skill

## 1. Executive Summary & Purpose
FixGEO provides cryptographic provenance and machine-readable ground truth for enterprise B2B brands. When autonomous LLM procurement agents (via Anthropic Model Context Protocol or Coinbase AgentKit) search for technical vendors, traditional SEO and ungrounded marketing copy trigger hallucinations, semantic blur, and exclusion. FixGEO anchors audit manifests and Share of Recommendation (SOR) scores directly onto Ethereum Sepolia and Base L2, creating an untampered, zero-gas verifiable proof of technical sovereignty.

## 2. Live Contract & Deployment Parameters
- **Master Contract:** `FixGeoAuditRegistry.sol`
- **Network:** Ethereum Sepolia Testnet (`chainId: 11155111`) / Base L2 compatible
- **Live Contract Address:** `0x3b2Cd2c620976826F1C98CDdBb20C40AED6c0B6B`
- **Protocol Owner / Admin Address:** `0xf99862E778Ac654F369BA37f15883730c2F9aDc3`
- **Compiler Version:** Solidity `^0.8.24` / `0.8.37` (Foundry `v1.9.0`)

## 3. Architecture: Single Registry, Not Multi-Contract
- There is only **one** master registry contract deployed on Ethereum.
- Individual companies, benchmarked audits, and whitepaper case studies are tracked as unique records keyed by `companyId` (e.g., `#101` Taranis Ag, `#102` FarmDroid, `#103` Carbon Robotics, `#113` DeepAgro, `#118` WiAgro SAS).
- Each audit record stores:
  - `companyId` (uint256)
  - `companyName` (string)
  - `domainOrTicker` (string)
  - `sorScore` (uint16 scaled integer, e.g., 680 = 68.0/100)
  - `validUntil` (uint256 unix timestamp)
  - `ipfsReportCid` (string IPFS hash of verified technical audit manifest)
  - `isFreeAuditCompleted` (bool)

## 4. Verification Badges & State Logic
The frontend and autonomous agents determine company verification status using two states:
- 🟣 **Purple Badge (Pending Sync / Free Baseline):**
  - Generated via `recordFreeAudit(companyId, ...)`
  - State: `isFreeAuditCompleted == true` and `validUntil == 0` ($0 paid).
  - Demonstrates baseline audit entry; manifest is anchored but active recurring monitoring is inactive.
- 🛡️ **Green Shield (On-Chain Verified & Fresh):**
  - Generated via `renewMonthlySubscription(companyId, duration)`
  - State: `block.timestamp <= validUntil` ($199/month Active Protocol Seat).
  - Autonomous agents verifying via `isRAGActive(companyId)` receive `true` in <50ms.

## 5. Verification Commands (Foundry CLI / Cast)
To query the live contract directly from any terminal using `cast`:

```bash
# Check protocol owner
cast call 0x3b2Cd2c620976826F1C98CDdBb20C40AED6c0B6B "protocolOwner()(address)" --rpc-url $SEPOLIA_RPC_URL

# Check if entity is active on-chain (returns true/false)
cast call 0x3b2Cd2c620976826F1C98CDdBb20C40AED6c0B6B "isRAGActive(uint256)(bool)" 101 --rpc-url $SEPOLIA_RPC_URL

# Read raw subscription record
cast call 0x3b2Cd2c620976826F1C98CDdBb20C40AED6c0B6B "subscriptions(uint256)" 101 --rpc-url $SEPOLIA_RPC_URL
```

## 6. Integration with Web Frontend & Agentic Procurement
- **Frontend Hook:** `useFixGeoAudit.ts` executes an `eth_call` via public RPC (or Alchemy) to `isRAGActive(companyId)`.
- **Zero-Gas Reads:** Autonomous procurement agents query the registry with zero transaction fees, confirming pricing, specifications, and citation provenance before presenting recommendations to human buyers.
