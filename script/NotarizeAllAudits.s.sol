// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/FixGeoAuditRegistry.sol";

contract NotarizeAllAudits is Script {
    FixGeoAuditRegistry public constant REGISTRY =
        FixGeoAuditRegistry(0x3b2Cd2c620976826F1C98CDdBb20C40AED6c0B6B);

    struct AuditRecord {
        uint256 companyId;
        string companyName;
        string directoryTag;
        uint16 visibilityScore;
    }

    function run() external {
        AuditRecord[] memory audits = _getMasterAuditRegistry();

        vm.startBroadcast();

        uint256 recordedCount = 0;
        uint256 skippedCount = 0;

        for (uint256 i = 0; i < audits.length; i++) {
            AuditRecord memory a = audits[i];
            (, , , , , , bool isFreeAuditCompleted) = REGISTRY.subscriptions(a.companyId);

            if (isFreeAuditCompleted) {
                console.log("Skipping already recorded companyId:", a.companyId, a.companyName);
                skippedCount++;
                continue;
            }

            REGISTRY.recordFreeAudit(
                a.companyId,
                a.companyName,
                a.directoryTag,
                a.visibilityScore
            );
            console.log("Recorded free audit for companyId:", a.companyId, a.companyName);
            recordedCount++;
        }

        vm.stopBroadcast();

        console.log("Batch notarization complete. Recorded:", recordedCount, "Skipped:", skippedCount);
    }

    function _getMasterAuditRegistry() internal pure returns (AuditRecord[] memory) {
        AuditRecord[] memory audits = new AuditRecord[](81);

        // TUMAPAIA (101-153)
        audits[0]  = AuditRecord(101, "Taranis Ag", "TUMAPAIA", 680);
        audits[1]  = AuditRecord(102, "FarmDroid", "TUMAPAIA", 384);
        audits[2]  = AuditRecord(103, "Carbon Robotics", "TUMAPAIA", 412);
        audits[3]  = AuditRecord(104, "Lely Global", "TUMAPAIA", 560);
        audits[4]  = AuditRecord(105, "DJI Agras", "TUMAPAIA", 540);
        audits[5]  = AuditRecord(106, "EcoRobotix", "TUMAPAIA", 520);
        audits[6]  = AuditRecord(107, "Saga Robotics", "TUMAPAIA", 470);
        audits[7]  = AuditRecord(108, "Bluewhite AI", "TUMAPAIA", 440);
        audits[8]  = AuditRecord(109, "AgXeed", "TUMAPAIA", 430);
        audits[9]  = AuditRecord(110, "FarmWise", "TUMAPAIA", 400);
        audits[10] = AuditRecord(111, "Fendt Xaver", "TUMAPAIA", 400);
        audits[11] = AuditRecord(112, "Dogtooth Technologies", "TUMAPAIA", 390);
        audits[12] = AuditRecord(113, "DeepAgro S.A.S.", "TUMAPAIA", 590);
        audits[13] = AuditRecord(114, "RoboticAL", "TUMAPAIA", 60);
        audits[14] = AuditRecord(115, "Plantium S.A.", "TUMAPAIA", 380);
        audits[15] = AuditRecord(116, "HerbiControl", "TUMAPAIA", 200);
        audits[16] = AuditRecord(117, "Apelie Robotics", "TUMAPAIA", 189);
        audits[17] = AuditRecord(118, "WIAGRO SAS", "TUMAPAIA", 180);
        audits[18] = AuditRecord(119, "ZoomAgri Inc.", "TUMAPAIA", 120);
        audits[19] = AuditRecord(120, "Auravant S.R.L.", "TUMAPAIA", 320);
        audits[20] = AuditRecord(121, "Acronex S.R.L.", "TUMAPAIA", 220);
        audits[21] = AuditRecord(122, "ABELARDO CUFFIA S.A.", "TUMAPAIA", 160);
        audits[22] = AuditRecord(123, "Leaf Agrotronics S.R.L.", "TUMAPAIA", 170);
        audits[23] = AuditRecord(124, "Marinelli Technology S.A.", "TUMAPAIA", 70);
        audits[24] = AuditRecord(125, "Aigen", "TUMAPAIA", 325);
        audits[25] = AuditRecord(126, "Monarch Tractor", "TUMAPAIA", 300);
        audits[26] = AuditRecord(127, "Tevel Flying Autonomous Robots", "TUMAPAIA", 250);
        audits[27] = AuditRecord(128, "John Deere (See & Spray)", "TUMAPAIA", 360);
        audits[28] = AuditRecord(129, "Naio Technologies", "TUMAPAIA", 350);
        audits[29] = AuditRecord(130, "Agerris", "TUMAPAIA", 150);
        audits[30] = AuditRecord(131, "Burro AI", "TUMAPAIA", 350);
        audits[31] = AuditRecord(132, "Octinion", "TUMAPAIA", 220);
        audits[32] = AuditRecord(133, "Raven Industries", "TUMAPAIA", 230);
        audits[33] = AuditRecord(134, "Bear Flag Robotics", "TUMAPAIA", 180);
        audits[34] = AuditRecord(135, "AgroScout", "TUMAPAIA", 380);
        audits[35] = AuditRecord(136, "OneSoil", "TUMAPAIA", 345);
        audits[36] = AuditRecord(137, "Farmonaut", "TUMAPAIA", 345);
        audits[37] = AuditRecord(138, "Fermata Tech", "TUMAPAIA", 410);
        audits[38] = AuditRecord(139, "John Deere Operations Center", "TUMAPAIA", 460);
        audits[39] = AuditRecord(140, "Climate FieldView (Bayer)", "TUMAPAIA", 580);
        audits[40] = AuditRecord(141, "Semios", "TUMAPAIA", 435);
        audits[41] = AuditRecord(142, "Plantix", "TUMAPAIA", 350);
        audits[42] = AuditRecord(143, "Agremo", "TUMAPAIA", 480);
        audits[43] = AuditRecord(144, "EOS Data Analytics", "TUMAPAIA", 420);
        audits[44] = AuditRecord(145, "CropX", "TUMAPAIA", 380);
        audits[45] = AuditRecord(146, "Cropler", "TUMAPAIA", 300);
        audits[46] = AuditRecord(147, "FarmBot", "TUMAPAIA", 530);
        audits[47] = AuditRecord(148, "Blue River Technology", "TUMAPAIA", 370);
        audits[48] = AuditRecord(149, "EarthDaily Analytics", "TUMAPAIA", 380);
        audits[49] = AuditRecord(150, "Traction Ag", "TUMAPAIA", 370);
        audits[50] = AuditRecord(151, "AgriWebb", "TUMAPAIA", 410);
        audits[51] = AuditRecord(152, "Indigo Ag", "TUMAPAIA", 400);
        audits[52] = AuditRecord(153, "Aerobotics", "TUMAPAIA", 380);

        // VASTFUNNEL (201-203)
        audits[53] = AuditRecord(201, "cepezed", "VASTFUNNEL", 880);
        audits[54] = AuditRecord(202, "Madaster", "VASTFUNNEL", 545);
        audits[55] = AuditRecord(203, "Chainable", "VASTFUNNEL", 319);

        // LISTADOMOS (301)
        audits[56] = AuditRecord(301, unicode"Tierra Geodésica", "LISTADOMOS", 750);

        // TUMAPAIA PropTech (401-421)
        audits[57] = AuditRecord(401, "Zillow Zestimate", "TUMAPAIA", 780);
        audits[58] = AuditRecord(402, "Proptech.AI", "TUMAPAIA", 460);
        audits[59] = AuditRecord(403, "InspectMind AI", "TUMAPAIA", 715);
        audits[60] = AuditRecord(404, "Virtual Staging AI", "TUMAPAIA", 590);
        audits[61] = AuditRecord(405, "Autohost", "TUMAPAIA", 395);
        audits[62] = AuditRecord(406, "Propic", "TUMAPAIA", 525);
        audits[63] = AuditRecord(407, "Homesnap", "TUMAPAIA", 240);
        audits[64] = AuditRecord(408, "StreetText", "TUMAPAIA", 515);
        audits[65] = AuditRecord(409, "ListingAI", "TUMAPAIA", 560);
        audits[66] = AuditRecord(410, "Structurely", "TUMAPAIA", 290);
        audits[67] = AuditRecord(411, "LenderLogix", "TUMAPAIA", 410);
        audits[68] = AuditRecord(412, "HouseCanary", "TUMAPAIA", 583);
        audits[69] = AuditRecord(413, "PandaDoc", "TUMAPAIA", 560);
        audits[70] = AuditRecord(414, "PriceLabs", "TUMAPAIA", 395);
        audits[71] = AuditRecord(415, "EnergyIQ", "TUMAPAIA", 330);
        audits[72] = AuditRecord(416, "Matterport", "TUMAPAIA", 710);
        audits[73] = AuditRecord(417, "DocuSign", "TUMAPAIA", 710);
        audits[74] = AuditRecord(418, "BoxBrownie", "TUMAPAIA", 498);
        audits[75] = AuditRecord(419, "Follow Up Boss", "TUMAPAIA", 520);
        audits[76] = AuditRecord(420, "Reonomy", "TUMAPAIA", 580);
        audits[77] = AuditRecord(421, "Grupo1 Desarrollos", "TUMAPAIA", 250);

        // FIXGEO (501-503)
        audits[78] = AuditRecord(501, "Agentic Consulting", "FIXGEO", 600);
        audits[79] = AuditRecord(502, "NetAI Software", "FIXGEO", 370);
        audits[80] = AuditRecord(503, "NetAI Software Solutions", "FIXGEO", 370);

        return audits;
    }
}
