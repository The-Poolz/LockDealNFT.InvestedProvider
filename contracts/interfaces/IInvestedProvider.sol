// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@poolzfinance/poolz-helper-v2/contracts/interfaces/IProvider.sol";

interface IInvestedProvider is IProvider {
    /**
     * @notice Called when a new investment pool is created.
     * @dev This function is expected to handle any setup or initialization logic for the new pool.
     * @param poolId The ID of the pool being created.
     * @param signer The address that signed the creation transaction.
     */
    function onCreation(uint256 poolId, address signer) external;

    /**
     * @notice Called when an investment is made in the pool.
     * @dev This function handle the logic associated with processing the investment,
     * such as updating the pool's state or transferring funds.
     * @param poolId The ID of the pool receiving the investment.
     * @param amount The amount of the investment.
     */
    function onInvest(uint256 poolId, uint256 amount) external;

    error NotInvestProvider();
    error InvestProviderZeroAddress();
}
