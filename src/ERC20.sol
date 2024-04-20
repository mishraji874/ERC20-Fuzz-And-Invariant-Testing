// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {IERC20} from "./IERC20.sol";
/**
 *  @title ERC-20 implementation.
 */

contract ERC20 is IERC20 {
    ////////////////////////////////////////////////////////////
    //                        VARIABLES                       //
    ////////////////////////////////////////////////////////////
    string public override name;
    string public override symbol;
    uint8 public immutable override decimals;
    uint256 public override totalSupply;
    mapping(address => uint256) public override balanceOf;
    mapping(address => mapping(address => uint256)) public override allowance;
    // PERMIT_TYPEHASH = keccak256("Permit(address owner, address spender, uint256 value, uint256 nonce, uint256 deadline)");
    bytes32 public constant override PERMIT_TYPEHASH =
        0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
    mapping(address => uint256) public override nonces;
    ////////////////////////////////////////////////////////////
    //                      CONSTRUCTOR                       //
    ////////////////////////////////////////////////////////////
    /**
     *  @param _name     The name of the token.
     *  @param _symbol   The symbol of the token.
     *  @param _decimals The decimal precision used by the token.
     */

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }
    ////////////////////////////////////////////////////////////
    //                   EXTERNAL FUNCTION                    //
    ////////////////////////////////////////////////////////////

    function approve(address _spender, uint256 _amount) public virtual override returns (bool _success) {
        _approve(msg.sender, _spender, _amount);
        return true;
    }

    function decreaseAllowance(address _spender, uint256 _subtractedAmount)
        public
        virtual
        override
        returns (bool _success)
    {
        _decreaseAllowance(msg.sender, _spender, _subtractedAmount);
        return true;
    }

    function increaseAllowance(address _spender, uint256 _addedAmount)
        public
        virtual
        override
        returns (bool success_)
    {
        _approve(msg.sender, _spender, allowance[msg.sender][_spender] + _addedAmount);
        return true;
    }

    function permit(
        address _owner,
        address _spender,
        uint256 _amount,
        uint256 _deadline,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) public virtual override {
        require(_deadline >= block.timestamp, "ERC20:P:EXPIRED");
        require(
            uint256(_s) <= uint256(0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0)
                && (_v == 27 || _v == 28),
            "ERC20:P:MALLEABLE"
        );
        unchecked {
            bytes32 _digest = keccak256(
                abi.encodePacked(
                    "\\x19\\x01",
                    DOMAIN_SEPARATOR(),
                    keccak256(abi.encode(PERMIT_TYPEHASH, _owner, _spender, _amount, nonces[_owner]++, _deadline))
                )
            );
            address recoveredAddress_ = ecrecover(_digest, _v, _r, _s);
            require(recoveredAddress_ == _owner && _owner != address(0), "ERC20:P:INVALID_SIGNATURE");
        }
        _approve(_owner, _spender, _amount);
    }

    function transfer(address _recipient, uint256 _amount) public virtual override returns (bool _success) {
        _transfer(msg.sender, _recipient, _amount);
        return true;
    }

    function transferFrom(address _owner, address _recipient, uint256 _amount)
        public
        virtual
        override
        returns (bool _success)
    {
        _decreaseAllowance(_owner, msg.sender, _amount);
        _transfer(_owner, _recipient, _amount);
        return true;
    }

    function DOMAIN_SEPARATOR() public view override returns (bytes32 domainSeparator) {
        return keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256(bytes(name)),
                keccak256(bytes("1")),
                block.chainid,
                address(this)
            )
        );
    }
    ////////////////////////////////////////////////////////////
    //                  INTERNAL FUNCTIONS                    //
    ////////////////////////////////////////////////////////////

    function _approve(address _owner, address _spender, uint256 _amount) internal {
        emit Approval(_owner, _spender, allowance[_owner][_spender] = _amount);
    }

    function _burn(address _owner, uint256 _amount) internal {
        balanceOf[_owner] -= _amount;
        unchecked {
            totalSupply -= _amount;
        }
        emit Transfer(_owner, address(0), _amount);
    }

    function _decreaseAllowance(address _owner, address _spender, uint256 _subtractedAmount) internal {
        uint256 spenderAllowance = allowance[_owner][_spender];
        if (spenderAllowance != type(uint256).max) {
            _approve(_owner, _spender, spenderAllowance - _subtractedAmount);
        }
    }

    function _mint(address _recipient, uint256 _amount) internal {
        totalSupply += _amount;
        unchecked {
            balanceOf[_recipient] += _amount;
        }
        emit Transfer(address(0), _recipient, _amount);
    }

    function _transfer(address _owner, address _recipient, uint256 _amount) internal {
        balanceOf[_owner] -= _amount;
        unchecked {
            balanceOf[_recipient] += _amount;
        }
        emit Transfer(_owner, _recipient, _amount);
    }
}
