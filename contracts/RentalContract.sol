// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RentalContract {
    address public landlord;
    address public tenent;
    uint public rentAmount;
    uint public leaseTerm;
    uint public startTime;
    bool public isLeaseActive;

    event leaseCreated(address indexed landlord, address indexed tenent, uint startTime);
    event RentPaid(address indexed payer, uint amount);
    event leaseTerminated(address indexed terminator);

    modifier onlyLandlord() {

        require(msg.sender == landlord, "Only the landlord can perform action");
        _;
    }

    modifier onlyTenent() {
        require(msg.sender == tenent, "Only tenent can perform the action");
        _;
    }

    constructor(
        address _tenent,
        uint _rentAmount,
        uint _leaseTerm

    ){
        landlord = msg.sender;
        tenent = _tenent;
        rentAmount = _rentAmount;
        leaseTerm = _leaseTerm;
    }

    function activatTheLease () external onlyLandlord {
        isLeaseActive = true;
        startTime = block.timestamp;
        emit leaseCreated(landlord, tenent, startTime);
    }

    function payRent() external payable onlyTenent {
        require(isLeaseActive, "The lease is not active");
        require(msg.value == rentAmount, "Incorrect rent amount sent.");
        emit RentPaid(msg.sender, msg.value);
    }

    function terminateLease() external onlyLandlord {
        require(block.timestamp >= startTime + leaseTerm, "The lease term has not ended");
        isLeaseActive = false;
        emit leaseTerminated(landlord);
    }

    function withdrawFunds() external onlyLandlord {
        payable (landlord).transfer(address(this).balance);
    }
}