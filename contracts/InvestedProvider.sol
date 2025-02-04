// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./InvestedState.sol";
import "@ironblocks/firewall-consumer/contracts/FirewallConsumer.sol";

/// @title InvestedProvider
/// @notice This is a contract as a marker of the invested amount.
/// Don't use it for transfering the invested amount. It's just for showing the ownership of the invested amount
contract InvestedProvider is InvestedState, FirewallConsumer {
    error ZeroAddress();

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
        uint256,
        uint256[] calldata
    ) external firewallProtected {
        revert("no data to register");
    }

    function getParams(
        uint256
    ) external pure returns (uint256[] memory params) {}

    function beforeTransfer(
        address,
        address,
        uint256
    ) external override firewallProtected {
        revert("transfer is not allowed for invested provider");
    }
}
