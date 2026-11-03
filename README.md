# FixGEO On-Chain Trust & Audit Registry (`fixgeo-contracts`)

> Cryptographic provenance and machine-readable ground truth for Generative Engine Optimization (GEO) and autonomous AI procurement agents.

[![Foundry](https://img.shields.io/badge/Built%20with-Foundry-FF4F00.svg)](https://getfoundry.sh/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Sepolia Contract](https://img.shields.io/badge/Sepolia-0x3b2Cd...-brightgreen.svg)]([suspicious link removed])

## Overview

When autonomous LLM procurement agents (via Anthropic Model Context Protocol or Coinbase AgentKit) search for enterprise B2B vendors, traditional marketing copy and un-indexed client-side SPAs cause hallucinations, semantic blur, and exclusion. 

`FixGeoAuditRegistry.sol` provides an immutable on-chain notary on Ethereum Sepolia (and Base L2). It anchors company baseline Share of Recommendation (SOR) scores and IPFS hashes of verified technical manifests (`llms.txt`, JSON-LD graphs).

## Verified Live Deployment

- **Network:** Ethereum Sepolia (`Chain ID: 11155111`) / Base L2 compatible
- **Contract Address:** [`0x3b2Cd2c620976826F1C98CDdBb20C40AED6c0B6B`]([suspicious link removed])
- **Protocol Owner:** `0xf99862E778Ac654F369BA37f15883730c2F9aDc3`
- **Compiler:** Solidity `^0.8.24` / `0.8.37` (Foundry `v1.9.0`)

## Core Architecture

The registry avoids deploying individual contracts per company. Instead, a single master registry tracks entities by `companyId`:

```text
┌────────────────────────────────────────────────────────┐
│  FixGeoAuditRegistry.sol (Ethereum Sepolia / Base L2)  │
│  Live: 0x3b2Cd2c620976826F1C98CDdBb20C40AED6c0B6B     │
└──────────────────────────┬─────────────────────────────┘
                           │ 
                           │ <50ms zero-gas eth_call: isRAGActive(companyId)
                           ▼
┌────────────────────────────────────────────────────────┐
│  AI Procurement Agents (Anthropic MCP / Coinbase Kit)  │
│  Web2 Frontends (useFixGeoAudit.ts & FixGeoBadge.tsx)  │
└──────────────────────────┬─────────────────────────────┘
                           ▼
               What the visitor sees:
   🟣 Purple Badge: Baseline audit created (\$0 paid)
   🛡️ Green Shield: Active \$199/mo client (Verified On-Chain)
