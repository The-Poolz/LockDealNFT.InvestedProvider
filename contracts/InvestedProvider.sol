// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./InvestedModifiers.sol";
import "@ironblocks/firewall-consumer/contracts/FirewallConsumer.sol";

/// @title InvestedProvider
/// @notice This is a contract as a marker of the invested amount.
/// Don't use it for transfering the invested amount. It's just for showing the ownership of the invested amount
contract InvestedProvider is InvestedModifiers, FirewallConsumer {
    constructor(ILockDealNFT _lockDealNFT) {
        if (address(_lockDealNFT) == address(0)) revert ZeroAddress();
        lockDealNFT = _lockDealNFT;
        name = "InvestedProvider";
    }

    /// Close withdraw option for the invested provider
    function getWithdrawableAmount(
        uint256
    ) public pure override returns (uint256) {
        return 0;
    }

    // close withdraw option for the invested provider
    function withdraw(
        uint256
    ) external firewallProtected returns (uint256, bool) {
        revert("withdraw is not allowed for invested provider");
    }

    function split(uint256, uint256, uint256) external firewallProtected {
        revert("split is not allowed for invested provider");
    }

    function registerPool(
        uint256 poolId,
        uint256[] calldata params
    )
        external
        firewallProtected
        onlyProvider
        validProvider(poolId)
        validParamsLength(params.length, currentParamsTargetLength())
    {
        poolIdToAmount[poolId] = params[0];
        poolIdToInvestId[poolId] = params[1];
        emit UpdateParams(poolId, params);
    }

    function getParams(
        uint256 poolId
    ) external view returns (uint256[] memory params) {
        params = new uint256[](2);
        params[0] = poolIdToAmount[poolId];
        params[1] = poolIdToInvestId[poolId];
    }
}
