// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@poolzfinance/lockdeal-nft/contracts/SimpleProviders/DealProvider/DealProviderState.sol";
import "./InvestedState.sol";

/// @title InvestedModifiers
abstract contract InvestedModifiers is DealProviderState, InvestedState {
    error InvalidParamsLength(uint256 providedLength, uint256 requiredLength);
    error InvalidProviderAddress(address sender);
    error InvalidProviderPoolId(uint256 poolId);
    error ZeroAddress();

    // Modifier to check if parameters length is valid
    modifier validParamsLength(uint256 paramsLength, uint256 minLength) {
        if (paramsLength > minLength) {
            revert InvalidParamsLength(paramsLength, minLength);
        }
        _;
    }

    // Modifier to check if the caller is a valid provider
    modifier onlyProvider() {
        if (!lockDealNFT.approvedContracts(msg.sender)) {
            revert InvalidProviderAddress(msg.sender);
        }
        _;
    }

    // Modifier to validate the provider for a given poolId
    modifier validProvider(uint256 poolId) {
        if (lockDealNFT.poolIdToProvider(poolId) != this) {
            revert InvalidProviderPoolId(poolId);
        }
        _;
    }
}
