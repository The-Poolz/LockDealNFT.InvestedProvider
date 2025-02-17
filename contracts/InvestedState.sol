// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@poolzfinance/lockdeal-nft/contracts/SimpleProviders/Provider/ProviderState.sol";

/// @title InvestedState
abstract contract InvestedState is ProviderState {
    ///@dev each provider decides how many parameters needs to be stored
    function currentParamsTargetLength()
        public
        view
        virtual
        override
        returns (uint256)
    {
        return 0;
    }
}
