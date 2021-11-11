// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;

contract Test {
    uint256 public a = 999; // That's storage

    function f(uint256 x) public view returns (uint256 r) {
        // int b; // That's memory
        assembly {
            r := mul(x, sload(a.slot))
        }
    }

    function f2(uint256 x) public {
        // uint b; // That's memory
        assembly {
            //   let b :=
            sstore(a.slot, mul(x, sload(a.slot)))
        }
        // a = b;
    }

    function f3(uint256 x) public {
        a = a * x;
    }
}
