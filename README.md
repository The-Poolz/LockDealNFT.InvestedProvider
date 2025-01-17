# InvestedProvider

[![Build and Test](https://github.com/The-Poolz/LockDealNFT.InvestedProvider/actions/workflows/node.js.yml/badge.svg)](https://github.com/The-Poolz/LockDealNFT.InvestedProvider/actions/workflows/node.js.yml)
[![codecov](https://codecov.io/gh/The-Poolz/LockDealNFT.InvestedProvider/graph/badge.svg)](c)
[![CodeFactor](https://www.codefactor.io/repository/github/the-poolz/LockDealNFT.InvestedProvider/badge)](https://www.codefactor.io/repository/github/the-poolz/LockDealNFT.InvestedProvider)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/The-Poolz/LockDealNFT.InvestedProvider/blob/master/LICENSE)

**InvestedProvider** is a smart contract that serves as proof of investment. Each time participants invest in an **IDO**, they will receive an **InvestedProvider NFT** as a mark and proof of successful investment.

### Navigation

-   [Installation](#installation)
-   [Overview](#overview)
-   [UML](#investprovider-diagram)
-   [License](#license)

## Installation

**Install the packages:**

```console
npm i
```

**Compile contracts:**

```console
npx hardhat compile
```

**Run tests:**

```console
npx hardhat test
```

**Run coverage:**

```console
npx hardhat coverage
```

**Deploy:**

```console
npx truffle dashboard
```

```console
npx hardhat run ./scripts/deploy.ts --network truffleDashboard
```

## Overview

**The InvestedProvider** contract is designed to track and prove investment participation in **IDOs**. It is not used for transferring invested amounts but for confirming ownership of investments through NFTs. The contract integrates with the LockDealNFT system to manage provider and deal-related states.

### Key Features:

-   Proof of Investment: Provides an NFT as proof of successful investment.
-   Security Modifiers: Includes checks for valid parameters and provider addresses to ensure secure operation.
-   Firewall Protection: Utilizes firewall protections to prevent unauthorized actions like withdrawals and splits.
-   Provider Registration: Manages the registration of investment pools, associating them with specific investment IDs and amounts

## UML

Below is a simplified representation of the contract structure and interactions:
![classDiagram](https://github.com/user-attachments/assets/7d7dc24e-e7eb-4901-8dd2-aef6dae191d7)

## License

[The-Poolz](https://poolz.finance/) Contracts is released under the [MIT License](https://github.com/The-Poolz/LockDealNFT.InvestedProvider/blob/master/LICENSE).
