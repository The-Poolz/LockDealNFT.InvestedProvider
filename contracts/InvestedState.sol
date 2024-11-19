// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IInvestedProvider.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@poolzfinance/dispenser-provider/contracts/DispenserProvider.sol";

abstract contract InvestedState is DispenserProvider, IInvestedProvider, Ownable {
    address public immutable investProvider;
}
