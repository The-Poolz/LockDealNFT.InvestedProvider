// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./InvestedState.sol";

abstract contract InvestedModifiers is InvestedState {
    modifier onlyInvestProvider() {
        if (msg.sender != investProvider) {
            revert NotInvestProvider();
        }
        _;
    }
}
