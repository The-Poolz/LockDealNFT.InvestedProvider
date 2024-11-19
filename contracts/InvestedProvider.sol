// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./InvestedModifiers.sol";

contract InvestedProvider is InvestedModifiers {
    constructor(
        ILockDealNFT _lockDealNFT,
        address _investProvider
    ) DispenserProvider(_lockDealNFT) {
        if (_investProvider == address(0)) revert InvestProviderZeroAddress();
        investProvider = _investProvider;
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
