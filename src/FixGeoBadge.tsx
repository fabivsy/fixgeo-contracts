import React from 'react';
import { useFixGeoAudit } from './useFixGeoAudit';

interface FixGeoBadgeProps {
  companyId: number;
  showScore?: boolean;
  className?: string;
}

export const FixGeoBadge: React.FC<FixGeoBadgeProps> = ({
  companyId,
  showScore = true,
  className = '',
}) => {
  const { active, formattedScore, directoryTag, loading, error } = useFixGeoAudit(companyId);

  const etherscanUrl = "https://sepolia.etherscan.io/address/0x3b2Cd2c620976826F1C98CDdBb20C40AED6c0B6B";

  // Base badge styling (dark-mode friendly)
  const baseStyle: React.CSSProperties = {
    display: 'inline-flex',
    alignItems: 'center',
    gap: '6px',
    padding: '6px 14px',
    borderRadius: '9999px',
    fontSize: '12px',
    fontWeight: 700,
    letterSpacing: '0.5px',
    textDecoration: 'none',
    cursor: 'pointer',
    transition: 'all 0.2s ease',
  };

  if (loading) {
    return (
      <span
        style={{
          ...baseStyle,
          background: 'rgba(31, 41, 55, 0.5)',
          color: '#9ca3af',
          border: '1px solid #374151',
        }}
        className={className}
      >
        ⏳ Querying On-Chain...
      </span>
    );
  }

  if (error) {
    return null; // Gracefully hide if network fails
  }

  // State 1: Active Subscription (TuMapaIA vs VastFunnel)
  if (active) {
    const isVastFunnel = directoryTag === 'VASTFUNNEL';
    const badgeText = isVastFunnel ? '🟢 FIXGEO VERIFIED' : '🛡️ FIXGEO AUDITED [ON-CHAIN VERIFIED]';

    return (
      <a
        href={etherscanUrl}
        target="_blank"
        rel="noopener noreferrer"
        title="Verified on Ethereum Sepolia by FixGEO Protocol"
        style={{
          ...baseStyle,
          background: 'rgba(16, 185, 129, 0.15)',
          color: '#34d399',
          border: '1px solid rgba(52, 211, 153, 0.4)',
          boxShadow: '0 0 15px rgba(52, 211, 153, 0.15)',
        }}
        className={className}
      >
        <span>{badgeText}</span>
        {showScore && <span style={{ opacity: 0.75, fontWeight: 500 }}>({formattedScore})</span>}
      </a>
    );
  }

  // State 2: Baseline Completed / Retainer Pending (ListadoMos)
  return (
    <a
      href={etherscanUrl}
      target="_blank"
      rel="noopener noreferrer"
      title="Baseline Audit Recorded • Active Retainer Pending"
      style={{
        ...baseStyle,
        background: 'rgba(168, 85, 247, 0.15)',
        color: '#c084fc',
        border: '1px solid rgba(168, 85, 247, 0.4)',
        boxShadow: '0 0 15px rgba(168, 85, 247, 0.15)',
      }}
      className={className}
    >
      <span>🟣 [ VALIDACIÓN FORENSE: PENDIENTE ]</span>
    </a>
  );
};

export default FixGeoBadge;