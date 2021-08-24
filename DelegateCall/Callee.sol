// SPDX-License-Identifier: MIT LICENSE

pragma solidity ^0.8.7;

contract Callee {
    uint256 public value  ;
    address public setter ;
    
    function setValue(uint256 v) public returns (bool success) {
        value = v;
        setter = msg.sender;
        return true;
    }
}