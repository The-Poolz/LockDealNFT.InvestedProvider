// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./InvestedModifiers.sol";

contract InvestedProvider is InvestedModifiers {
    constructor(
        ILockDealNFT _lockDealNFT
    ) DispenserProvider(_lockDealNFT) Ownable(msg.sender) {
        name = "InvestedProvider";
    }

    function onCreation(
        uint256 poolId,
        address signer
    ) external override onlyInvestProvider {
        uint256 newPoolId = lockDealNFT.mintForProvider(signer, this);
        lockDealNFT.cloneVaultId(newPoolId, poolId);
    }

    function onInvest(
        uint256 poolId,
        uint256 amount
    ) external override onlyInvestProvider {
        poolIdToAmount[poolId] += amount;
        // emit UpdateParams(poolId, params); 
    }
}
