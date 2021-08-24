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
    
    // callcode is supported only in assembly since v0.5.x
    function setValueByCallCode(address callee, uint256 _value) public returns (bool ) {
        bytes memory _calldata = abi.encodeWithSignature("setValue(uint256)", _value);
        address _dst = callee;
         assembly {
            let result := callcode(
                sub(gas(), 10000),
                _dst,
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