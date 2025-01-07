// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@poolzfinance/poolz-helper-v2/contracts/interfaces/ILockDealNFT.sol";
import "@poolzfinance/lockdeal-nft/contracts/SimpleProviders/DealProvider/DealProvider.sol";

contract MockInvestProvider is DealProvider {
    constructor(ILockDealNFT _lockDealNFT) DealProvider(_lockDealNFT) {}

    function createInvestedPool(
        IProvider provider,
        uint256 amount,
        uint256 sourcePoolId
    ) external returns (uint256 poolId) {
        poolId = lockDealNFT.mintForProvider(msg.sender, provider);
        lockDealNFT.cloneVaultId(poolId, sourcePoolId);
        // register the amount in the invested provider
        uint256[] memory params = new uint256[](1);
        params[0] = amount;
        provider.registerPool(poolId, params);
    }
}
