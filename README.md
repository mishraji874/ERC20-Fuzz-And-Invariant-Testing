# ERC20 Fuzz and Invariant Testing Using Foundry

## Overview

This project provides a comprehensive suite for fuzz and invariant testing of ERC20 token contracts using Foundry. Fuzz testing involves supplying random inputs to the contract functions to uncover unexpected behaviors, while invariant testing focuses on verifying properties that should always hold true throughout the contract's execution.

## Features

- Fuzz Testing: Automatically generates random inputs to test ERC20 token contracts for unexpected behaviors.
- Invariant Testing: Verifies properties that should always hold true during the contract's execution, ensuring its integrity and correctness.
- Customizable: Easily customize test parameters and properties to suit your specific contract requirements.
- Foundry Integration: Seamless integration with Foundry for efficient testing and analysis.

## Installation

Follow these steps to set up and deploy the decentralized token exchange smart contract:

1.  Clone the Repository:

```bash
git clone https://github.com/mishraji874/ERC20-Fuzz-And-Invariant-Testing.git
```

2. Navigate to the Project Directory:

```bash
cd ERC20-Fuzzing-And-Invariant-Testing
```

### Foundry Commands:

Here are the Foundry commands for compiling, deploying, interacting with, and testing the smart contracts:

1. Initialize Foundry:

```bash
forge init
```

2. Install dependenices:

```bash
forge install
```

3. Compile smart contracts:

```bash
forge compile
```

4. Test Contracts:

```bash
forge test
```

5. Make the ```.env``` file and add your SEPOLIA_RPC_URL, PRIVATE_KEY and your ETHERSCAN_API_KEY for verification of the deployed contract.

6. Deploy Smart Contract:

    If deploying to the test network run the following command:
    ```bash
    forge script script/DeployERC20.s.sol
    ```

    If deploying to the Sepolia test network run the following command:
    ```bash
    forge script script/DeployERC20.s.sol --rpc-url ${SEPOLIA_RPC_URL} --private-key ${PRIVATE_KEY}
    ```

    And, for verification from the Etherscan about the deployed contract run the following command:
    ```bash
    forge script script/DeployERC20.s.sol --rpc-url ${SEPOLIA_RPC_URL} --private-key ${PRIVATE_KEY} --verify ${ETHERSCAN_API_KEY}
    ```

## License:

This project is licensed under the MIT License.