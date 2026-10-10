import { useState, useEffect } from 'react';
import { ethers } from 'ethers';

// Live FixGEO Protocol Configuration
const RPC_URL = "https://eth-sepolia.g.alchemy.com/v2/alch_BybEztig02lGX4HNeSrue";
const CONTRACT_ADDRESS = "0x3b2Cd2c620976826F1C98CDdBb20C40AED6c0B6B";

const ABI = [
  "function isRAGActive(uint256 companyId) view returns (bool active, uint16 score, string ragHash)",
  "function subscriptions(uint256 companyId) view returns (uint256, string, string, uint16, uint256, string, bool)"
];

export interface FixGeoAuditData {
  active: boolean;
  score: number;
  formattedScore: string;
  ragHash: string;
  directoryTag: string;
  loading: boolean;
  error: string | null;
}

export function useFixGeoAudit(companyId: number): FixGeoAuditData {
  const [data, setData] = useState<FixGeoAuditData>({
    active: false,
    score: 0,
    formattedScore: "-- / 100",
    ragHash: "",
    directoryTag: "",
    loading: true,
    error: null,
  });

  useEffect(() => {
    let isMounted = true;

    async function fetchOnChainAudit() {
      try {
        const provider = new ethers.JsonRpcProvider(RPC_URL);
        const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, provider);

        // 1. Query active status and RAG manifest
        const [active, score, ragHash] = await contract.isRAGActive(companyId);

        // 2. Query directory metadata
        const [, , directoryTag] = await contract.subscriptions(companyId);

        if (isMounted) {
          setData({
            active: Boolean(active),
            score: Number(score),
            formattedScore: (Number(score) / 10).toFixed(1) + " / 100",
            ragHash: ragHash || "",
            directoryTag: directoryTag || "",
            loading: false,
            error: null,
          });
        }
      } catch (err: any) {
        if (isMounted) {
          setData(prev => ({
            ...prev,
            loading: false,
            error: err.message || "Failed to query FixGEO on-chain oracle",
          }));
        }
      }
    }

    if (companyId) {
      fetchOnChainAudit();
    }

    return () => {
      isMounted = false;
    };
  }, [companyId]);

  return data;
}