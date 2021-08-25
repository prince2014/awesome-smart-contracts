// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.7;

contract Caller {
    uint256 public value  ;
    address public setter ;
    
    event Log(bool success, bytes calleeSuccess);

    function setValueByCall(address callee, uint256 _value) public returns (bool success) {
        // bool _success ;
        // bytes memory data;
        // (bool _success,bytes memory  data) =  callee.call(abi.encodeWithSignature("setValue", _value));
        (bool _success,) =  callee.call(abi.encodeWithSignature("setValue(uint256)", _value));
       
        return _success;
    }
    
    function setValueByDelegateCall(address callee, uint256 _value) public returns (bool success) {
        // bool _success ;
        // bytes memory data;
        // (bool _success,bytes memory  data) =  callee.call(abi.encodeWithSignature("setValue", _value));
        (bool _success,bytes memory _calleeSuccess) =  callee.delegatecall(abi.encodeWithSignature("setValue(uint256)", _value));
        emit Log(_success, _calleeSuccess);
        return _success;
    }
    
    function setValueByCallCode(address callee, uint256 _value) public returns (bool ) {
        bytes memory _calldata = abi.encodeWithSignature("setValue(uint256)", _value);
        address _dst = callee;
         assembly {
            // refer to https://docs.soliditylang.org/en/v0.5.3/assembly.html
            // sstore(0, call(gas(), address(), 42, 0, 0x20, 0x20, 0x20))
            // sstore(0, callcode(gas(), address(), 42, 0, 0x20, 0x20, 0x20))
            // sstore(0, delegatecall(gas(), address(), 0, 0x20, 0x20, 0x20))
            // sstore(0, staticcall(gas(), address(), 0, 0x20, 0x20, 0x20))

            let result := callcode(
                sub(gas(), 10000),
                _dst,
                0,
                add(_calldata, 0x20),
                mload(_calldata),
                0,
                0
            )
            let size := returndatasize()

            let ptr := mload(0x40)
            returndatacopy(ptr, 0, size)

            // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
            // if the call returned error data, forward it
            switch result
                case 0 {
                    revert(ptr, size)
                   
                }
                default {
                    return(ptr, size)
                }
        }
    }
}