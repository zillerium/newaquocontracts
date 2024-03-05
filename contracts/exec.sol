// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MultiSig {
    address[] public owners;
    uint public required;
    uint public transactionCount;
    uint txnid;
    
    struct Transaction {
        address dest;
        uint256 value;
        bool executed;
        bytes data;
    }

    mapping (uint => mapping (address => bool)) public confirmations;
     
    mapping(uint => Transaction) public transactions;

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "no owners");
        require(_required > 0, "no confirmations");
        require(_required <= _owners.length, "too few");

        required = _required;
        owners = _owners;
    }

    function executeTransaction(uint _txnid) public {
        require(isConfirmed(_txnid), "Transaction not confirmed yet");

        Transaction storage txn = transactions[_txnid];

        require(!txn.executed, "Transaction already executed");

        //(bool success, ) = txn.dest.call{value: txn.value}("");
        //require(success, "Transaction failed");

        (bool success, ) = txn.dest.call{ value: txn.value}(txn.data);
        require(success, "Transaction failed");

        txn.executed = true;
    }


    function isConfirmed (uint _txnid) public view returns(bool) {
        if (getConfirmationsCount(_txnid)> 1) return true; else return false;
    }

    receive() payable external {

    } 

    function submitTransaction(address addr, uint value, bytes memory _data) external {
        uint txnid1 = addTransaction(addr, value, _data);
        confirmTransaction(txnid1);
    }

    function addTransaction(address _dest, uint _value, bytes memory _data) 
         internal returns (uint) {
        Transaction memory txn = Transaction({
            dest: _dest,
            value: _value,
            executed: false,
            data: _data
        });
        transactions[transactionCount] = txn;
        transactionCount++;
        return (transactionCount - 1);
    }

    function isOwner(address _address) public view returns (bool) {
        for (uint i = 0; i < owners.length; i++) {
            if (owners[i] == _address) {
                return true;
            }
        }
        return false;
    }

 function getConfirmationsCount(uint _transactionId) public view returns (uint256) {
    uint256 count = 0;
    for (uint i = 0; i < owners.length; i++) {
        if (confirmations[_transactionId][owners[i]]) {
            count++;
        }
    }
    return count;
}

function confirmTransaction(uint _transactionId) public {
    require(isOwner(msg.sender), "not owner");
    require(!confirmations[_transactionId][msg.sender], "already confirmed");

    confirmations[_transactionId][msg.sender] = true;

    if (isConfirmed(_transactionId)) {
        executeTransaction(_transactionId);
    }
}

 

}
