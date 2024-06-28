// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IInvestedProvider.sol";
import "@poolzfinance/dispenser-provider/contracts/DispenserProvider.sol";

contract InvestedProvider is DispenserProvider, IInvestedProvider {
    constructor(ILockDealNFT _lockDealNFT) DispenserProvider(_lockDealNFT) {
        name = "InvestedProvider";
    }

    function onCreation(uint256 poolId, bytes calldata data) external override {
        // Do something
    }

    function onInvest(
        uint256 poolId,
        uint256 amount,
        bytes calldata data
    ) external override {
        // Do something
    }
}
