// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Foo {
  uint internal x; // Storage slot #0
  mapping (uint => uint) internal y; // Storage slot #1
  uint [] internal a = [5,4,3,2,1]; // Storage slot #2
  uint [] internal b = [6, 7, 8]; // Storage slot #3

  function zLength () public view returns (uint r) {
      assembly {
        r := sload (2)
      }
    }
    
    function zElement (uint i) public view returns (uint r) {
      assembly {
        mstore (0, 3) // 3 is the storage slot 3, which is b
        r := sload (add (keccak256 (0, 32), i)) // same to read b[i]
      }
    }
}