// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IInvestedProvider.sol";
import "@poolzfinance/dispenser-provider/contracts/DispenserProvider.sol";

abstract contract InvestedState is DispenserProvider, IInvestedProvider {
    address public immutable investProvider;
}
