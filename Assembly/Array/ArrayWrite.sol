// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Array {
    // Several ways to initialize an array
    uint256[] public arr;
    uint256[] public arr2 = [1, 2, 3];
    // Fixed sized array, all elements initialize to 0
    uint256[10] public myFixedSizeArr;

    uint256[] public nftIds = [0, 1, 2, 3];

    uint256 public value1;

    uint256 public totalSupply = 10;

    // constructor( uint[] memory _nftIds) {
    //     nftIds = _nftIds;
    // }

    // constructor( uint start, uint end) {
    //     for (uint i = start; i < end; i ++) {
    //         nftIds.push(i);
    //     }
    // }

    function addIds(uint256 start, uint256 end) public {
        for (uint256 i = start; i < end; i++) {
            nftIds.push(i);
        }
    }

    function addIds2(uint256[] memory _nftIds) public {
        for (uint256 i = 0; i < _nftIds.length; i++) {
            nftIds.push(_nftIds[i]);
        }
    }

    function query()
        public
        view
        returns (
            uint256 _arr1,
            uint256 _arr2,
            uint256 _arr3,
            uint256 _arr4,
            uint256 _arr5,
            uint256 _arr6,
            uint256 _arr7
        )
    {
        assembly {
            _arr1 := sload(arr.slot)
            _arr2 := sload(arr2.slot)
            _arr3 := sload(myFixedSizeArr.slot)
            _arr4 := sload(nftIds.slot)
            _arr5 := sload(add(arr.slot, 1))

            mstore(0, nftIds.slot)
            _arr7 := sload(add(keccak256(0, 32), 2))
        }
    }

    function query2()
        public
        pure
        returns (
            uint256 result,
            uint256 res2,
            uint256 res3
        )
    {
        assembly {
            result := mload(0x40)
            res2 := mload(0x20)
            res3 := mload(0x60)
        }
    }

    function query3()
        public
        pure
        returns (
            uint256 res1,
            uint256 res2,
            uint256 res3,
            uint256 res4
        )
    {
        assembly {
            res1 := arr.slot
            res2 := arr2.slot
            res3 := myFixedSizeArr.slot
            res4 := nftIds.slot
        }
    }

    function query4(uint256 amount)
        public
        view
        returns (
            uint256[] memory newArr,
            uint256 res2,
            uint256[] memory finalRes
        )
    {
        assembly {
            //  let memOffset := msize() // Get the highest available block of memory
            //  mstore(add(memOffset, 0x00), 2) // Set size to 2
            //  mstore(add(memOffset, 0x20), 19) // array[0] = a
            //  mstore(add(memOffset, 0x40), 29) // array[1] = b

            //  let memOffset2 := msize() // Get the highest available block of memory
            //  mstore(add(memOffset2, 0x00), 3) // Set size to 2
            //  mstore(add(memOffset2, 0x20), 39) // array[0] = a
            //  mstore(add(memOffset2, 0x40), 49) // array[1] = b
            //  mstore(add(memOffset2, 0x60), 59) // array[1] = b

            // //  newArr:= mload(0x40)
            // //  mstore(add(newArr, mul(3, 0x20)), memOffset )
            // //  mstore(add(newArr, mul(6, 0x20)), memOffset2)

            //  mstore(0x40, add(memOffset, 0x60))

            //  newArr := memOffset

            //  res2 := mload(newArr) // read the the length of newArr

            finalRes := msize()
            let index := 0
            let len1 := sload(nftIds.slot) // 4
            let len2 := add(len1, amount)
            mstore(add(finalRes, 0x00), len2) // set size

            mstore(0, nftIds.slot)
            for {

            } lt(index, len1) {
                index := add(index, 1)
            } {
                let _arr7 := sload(add(keccak256(0, 32), index))

                mstore(add(finalRes, mul(add(index, 1), 0x20)), _arr7)
            }

            // mstore(add(finalRes, mul(add(0,1), 0x20)), 20)
            // mstore(add(finalRes, mul(add(1,1), 0x20)), 21)
            // mstore(add(finalRes, mul(add(2,1), 0x20)), 22)
            // mstore(add(finalRes, mul(add(3,1), 0x20)), 23)

            let i := 0
            let startId := sload(totalSupply.slot)
            for {

            } lt(i, amount) {
                i := add(i, 1)
            } {
                mstore(
                    add(finalRes, mul(add(1, add(len1, i)), 0x20)),
                    add(startId, i)
                )
            }

            mstore(0x40, add(finalRes, mul(add(len2, 1), 0x20)))
        }
    }

    function addIds4(uint256 amount) public {
        uint256[] memory myArr;
        assembly {
            let finalRes := msize()
            let index := 0
            let len1 := sload(nftIds.slot) // 4
            let len2 := add(len1, amount)
            mstore(add(finalRes, 0x00), len2) // set size

            mstore(0, nftIds.slot)
            for {

            } lt(index, len1) {
                index := add(index, 1)
            } {
                mstore(
                    add(finalRes, mul(add(index, 1), 0x20)),
                    sload(add(keccak256(0, 32), index))
                )
            }

            let i := 0
            let startId := sload(totalSupply.slot)
            for {

            } lt(i, amount) {
                i := add(i, 1)
            } {
                mstore(
                    add(finalRes, mul(add(1, add(len1, i)), 0x20)),
                    add(startId, i)
                )
            }

            mstore(0x40, add(finalRes, mul(add(len2, 1), 0x20)))

            myArr := finalRes
        }

        nftIds = myArr;
    }

    function addIds5(uint256 amount) public {
        assembly {
            let len1 := sload(nftIds.slot) // 4
            let len2 := add(len1, amount)
            sstore(nftIds.slot, len2)
            mstore(0, nftIds.slot)
            let i := 0
            let startId := sload(totalSupply.slot)
            for {

            } lt(i, amount) {
                i := add(i, 1)
            } {
                sstore(add(keccak256(0, 32), add(len1, i)), add(startId, i))
            }

            // sload(p)	 	storage[p]
            // sstore(p, v)	storage[p] := v
            sstore(totalSupply.slot, add(startId, amount))
        }
    }

    function concat(bytes32 b1, bytes32 b2)
        external
        pure
        returns (bytes memory)
    {
        bytes memory result = new bytes(64);
        assembly {
            mstore(add(result, 32), b1)
            mstore(add(result, 64), b2)
        }
        return result;
    }

    function addIds3(uint256 amount) public {
        assembly {
            // Load the lenght (first 32 bytes)
            // let len := mload(_nftIds)

            let result := mload(0x40) // 0x40 is the address where next free memory slot is stored in Solidity.

            let arr1 := sload(nftIds.slot) // nftIds lenght is 4
            let arr66 := arr1
            // mstore(add(result, 0x20), arr1) // add data to the array, data offset = 0x20 (1st 32 is reserved for size) & i*32 to pickup the right index
            // mstore(add(result, 0x20), arr66)
            let i := 0
            for {

            } lt(i, amount) {
                i := add(i, 1)
            } {
                // sum := add(sum, mload(data))
                let ele := mload(add(arr1, add(0x20, mul(i, 0x20)))) // docHash = _documentHashes[i], data offset = 0x20 (1st 32 is reserved for size) & i*32 to pickup the right index
                // mstore(result)
                // mstore(add(result, add(0x20, mul(counter, 0x20))), ele) // add data to the array, data offset = 0x20 (1st 32 is reserved for size) & i*32 to pickup the right index
            }

            // let i := 0 // uint i for the loop
            // // loop: //start loop
            // //     mstore(add(result, add(0x20, mul(counter, 0x20))), i) // add data to the array, data offset = 0x20 (1st 32 is reserved for size) & i*32 to pickup the right index
            // //     i := add(i,1) // increment for loop
            // // jumpi(loop, lt(i,len)) // stop loop when the lenght of _documenthashes is reached

            // for
            //     {  }
            //     lt(i, amount)
            //     { i := add(i, 1) }
            // {
            //     sum := add(sum, mload(data))
            // }

            // sstore(nftIds.slot, result)
            // sstore(value1.slot, result)
        }
    }

    function get(uint256 i) public view returns (uint256) {
        return arr[i];
    }

    // Solidity can return the entire array.
    // But this function should be avoided for
    // arrays that can grow indefinitely in length.
    function getArr() public view returns (uint256[] memory) {
        return arr;
    }

    function push(uint256 i) public {
        // Append to array
        // This will increase the array length by 1.
        arr.push(i);
    }

    function pop() public {
        // Remove last element from array
        // This will decrease the array length by 1
        arr.pop();
    }

    function getLength() public view returns (uint256) {
        return arr.length;
    }

    function remove(uint256 index) public {
        // Delete does not change the array length.
        // It resets the value at index to it's default value,
        // in this case 0
        delete arr[index];
    }

    // function examples() external {
    //     // create array in memory, only fixed size can be created
    //     uint[] memory a = new uint[](5);
    // }
}
