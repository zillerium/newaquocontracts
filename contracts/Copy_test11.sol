// SPDX-License-Identifier: BSD-2-Clause
pragma solidity ^0.8.16;

contract EmploymentContract {
    enum Status {
        NewEmployee,
        Associate,
        Terminated
    }

    Status public empStatus;
    Status public newEmp = Status.Associate;

    function setStatus(Status _status) external {
        empStatus = _status;
    }

    function isNewEmployee() external view 
        returns (bool) {
        return empStatus == Status.NewEmployee;
    }

}
