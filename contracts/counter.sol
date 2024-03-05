// SPDX-License-Identifier: BSD-2-Clause
pragma solidity ^0.8.16;

contract Enum {
    enum Status { 
        Pending, 
        Shipped, 
        Accepted, 
        Rejected, 
        Canceled 
    }
    Status public status;
}

 