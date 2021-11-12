// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.7;

abstract contract ContextMixin {
    function msgSender() internal view returns (address payable sender) {
        if (msg.sender == address(this)) {
            bytes memory array = msg.data;
            uint256 index = msg.data.length;
            assembly {
                // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
                sender := and(
                    mload(add(array, index)),
                    0xffffffffffffffffffffffffffffffffffffffff
                )
            }
        } else {
            sender = payable(msg.sender);
        }
        return sender;
    }
}

contract Callee is ContextMixin {
    uint256 private value;
    address private setter;

    event LogGas(uint256 gas, uint256 gasPrice);
    event IsContract(address sender, bool isContract);
    event MsgData(bytes data, uint256 dataLength);

    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }

    function setValue(uint256 v) public returns (bool success) {
        // require(!isContract(msg.sender), "cannot be invoked by a smart contract");
        // require(!isContract(_msgSender()), "cannot be invoked by a smart contract");
        if (isContract(_msgSender())) {
            revert();
        }

        if (isContract(_msgSender())) {
            emit IsContract(_msgSender(), true);
            emit MsgData(msg.data, msg.data.length);
        } else {
            emit IsContract(_msgSender(), false);
            emit MsgData(msg.data, msg.data.length);
        }

        if (isContract(msg.sender)) {
            emit IsContract(msg.sender, true);
            emit MsgData(msg.data, msg.data.length);
        } else {
            emit IsContract(msg.sender, false);
            emit MsgData(msg.data, msg.data.length);
        }

        emit LogGas(gasleft(), tx.gasprice);

        value = v;
        setter = _msgSender();

        emit LogGas(gasleft(), tx.gasprice);
        emit LogGas(gasleft(), block.gaslimit);

        return true;
    }

    function getValue() external view returns (uint256) {
        return value;
    }

    function getSetter() external view returns (address) {
        return setter;
    }

    // This is to support Native meta transactions
    // never use msg.sender directly, use _msgSender() instead
    function _msgSender()
        internal
        view
        virtual
        returns (address payable sender)
    {
        return ContextMixin.msgSender();
    }
}
