// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import {Script, console} from "forge-std/Script.sol";
import {ERC20} from "../src/ERC20.sol";

contract DeployERC20 is Script {
    ERC20 token;

    function run() external returns (ERC20) {
        vm.startBroadcast();
        token = new ERC20("Token", "TK", 18);
        vm.stopBroadcast();
        console.log("Contract is deployed at address: ", address(token));
    }
}
