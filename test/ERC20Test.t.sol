// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import {ERC20} from "../src/ERC20.sol";
import {Test} from "forge-std/Test.sol";
import {MockERC20} from "./MockERC20.t.sol";

contract ERC20Test is Test {
    MockERC20 internal _token;

    function setUp() public {
        _token = new MockERC20("Token", "TK", 18);
    }

    function testFuzzMetadata(string memory _name, string memory _symbol, uint8 _decimals) public {
        MockERC20 mockToken = new MockERC20(_name, _symbol, _decimals);

        assertEq(mockToken.name(), _name);
        assertEq(mockToken.symbol(), _symbol);
        assertEq(mockToken.decimals(), _decimals);
    }

    function testFuzzMint(address _account, uint256 _amount) public {
        _token.mint(_account, _amount);

        assertEq(_token.totalSupply(), _amount);
        assertEq(_token.balanceOf(_account), _amount);
    }

    function testFuzzBurn(address _account, uint256 _amount0, uint256 _amount1) public {
        if (_amount1 > _amount0) return;

        _token.mint(_account, _amount0);
        _token.burn(_account, _amount1);

        assertEq(_token.totalSupply(), _amount0 - _amount1);
        assertEq(_token.balanceOf(_account), _amount0 - _amount1);
    }

    function testFuzzApprove(address _account, uint256 _amount) public {
        assertTrue(_token.approve(_account, _amount));

        assertEq(_token.allowance(address(this), _account), _amount);
    }
}
