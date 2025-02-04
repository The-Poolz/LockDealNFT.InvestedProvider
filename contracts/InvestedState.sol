// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@poolzfinance/lockdeal-nft/contracts/SimpleProviders/Provider/ProviderState.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@poolzfinance/poolz-helper-v2/contracts/interfaces/IBeforeTransfer.sol";

/// @title InvestedState
abstract contract InvestedState is ProviderState, IERC165, IBeforeTransfer {
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

    /**
     * @dev Checks whether a contract supports the specified interface.
     * @param interfaceId Interface identifier.
     * @return A boolean indicating whether the contract supports the specified interface.
     */
    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override returns (bool) {
        return
            interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IBeforeTransfer).interfaceId;
    }
}
