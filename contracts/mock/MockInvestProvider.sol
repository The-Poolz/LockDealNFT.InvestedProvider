// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@poolzfinance/poolz-helper-v2/contracts/interfaces/ILockDealNFT.sol";
import "@poolzfinance/lockdeal-nft/contracts/SimpleProviders/DealProvider/DealProvider.sol";

contract MockInvestProvider is DealProvider {
    constructor(ILockDealNFT _lockDealNFT) DealProvider(_lockDealNFT) {}

    function createInvestedPool(
        IProvider provider,
        uint256[] calldata params,
        uint256 sourcePoolId
    ) external returns (uint256 poolId) {
        poolId = lockDealNFT.mintForProvider(msg.sender, provider);
        lockDealNFT.cloneVaultId(poolId, sourcePoolId);
        // register the amount in the invested provider
        provider.registerPool(poolId, params);
    }

    function callRegister(
        IProvider provider,
        uint256[] calldata params,
        uint256 poolId
    ) external {
        provider.registerPool(poolId, params);
    }
}
