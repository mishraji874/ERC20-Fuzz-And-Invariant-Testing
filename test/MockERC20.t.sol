//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import {Test} from "forge-std/Test.sol";
import {ERC20} from "../src/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor(string memory _name, string memory _symbol, uint8 _decimals) ERC20(_name, _symbol, _decimals) {}

    function mint(address _recipient, uint256 _amount) external {
        _mint(_recipient, _amount);
    }

    function burn(address _owner, uint256 _amount) external {
        _burn(_owner, _amount);
    }
}
