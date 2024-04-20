// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import {Test} from "forge-std/Test.sol";
import {MockERC20} from "./MockERC20.t.sol";

contract InvariantERC20Test is Test {
    MockERC20 internal _token;

    function setUp() public {
        _token = new MockERC20("Token", "TK", 18);
    }

    function testInvariantMetadataIsConstant() public {
        assertEq(_token.name(), "Token");
        assertEq(_token.symbol(), "TK");
        assertEq(_token.decimals(), 18);
    }

    function testInvariantMintingAffectsTotalSupplyAndBalance(address to, uint256 amount) public {
        vm.assume(to != address(0));

        uint256 preSupply = _token.totalSupply();

        _token.mint(to, amount);

        uint256 postSupply = _token.totalSupply();
        uint256 toBalance = _token.balanceOf(to);

        assertEq(postSupply, preSupply + amount, "Total supply did not increase correctly after minting");

        assertEq(toBalance, amount, "Recipient balance incorrect after minting");
    }

    function testInvariant_transferCorrectlyUpdatesBalances(
        address sender,
        address receiver,
        uint256 mintAmount,
        uint256 transferAmount
    ) public {
        vm.assume(sender != address(0) && receiver != address(0) && sender != receiver);
        vm.assume(mintAmount > 0 && transferAmount > 0 && mintAmount >= transferAmount);

        vm.prank(sender);
        _token.mint(sender, mintAmount);

        uint256 initialSenderBalance = _token.balanceOf(sender);
        uint256 initialReceiverBalance = _token.balanceOf(receiver);
        uint256 initialTotalSupply = _token.totalSupply();

        vm.prank(sender);
        _token.transfer(receiver, transferAmount);

        uint256 expectedSenderBalance = initialSenderBalance - transferAmount;
        uint256 expectedReceiverBalance = initialReceiverBalance + transferAmount;

        assertEq(_token.balanceOf(sender), expectedSenderBalance, "Sender balance incorrect after transfer");

        assertEq(_token.balanceOf(receiver), expectedReceiverBalance, "Receiver balance incorrect after transfer");

        assertEq(_token.totalSupply(), initialTotalSupply, "Total supply should remain constant after transfers");
    }
}
