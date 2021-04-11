// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./CustomerStorage.sol";

contract InsurancePool is CustomerStorage {
    address public owner;
    event Received(address indexed, address, uint256);
    event Created(address indexed, address, uint256);
    event Claim(address indexed, address, uint256);
    event Estimate(address indexed, address);

    constructor() public {
        owner = msg.sender;
    }

    function createNewCustomer(address payable newCustomerId, CustomerStorage.InsuranceType insuranceType) external payable {
        require(CustomerStorage.customers[newCustomerId].isNewEntity == false, "user already exists");
        CustomerStorage.storeCustomer(newCustomerId, msg.value, insuranceType);
        emit Created(msg.sender, msg.sender, msg.value);
    }
    
    // get insurance information for user 
    function getInsuranceInformation(address customer) public view returns (CustomerStorage.InsuranceType, uint256,  uint256, uint256, uint256) {
        return CustomerStorage.getCustomer(customer);
    }

    // deposit ammount
    function depositToInsurance(address customerId) payable public returns (uint256, uint256) {
        require(CustomerStorage.customers[customerId].customerId == msg.sender);
        emit Received(customerId, customerId, msg.value);
        return CustomerStorage.updateCustomerDeposit(customerId, msg.value);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    function estimateClaimAmount(address customerId) public view  returns (uint256) {
        (CustomerStorage.InsuranceType insuranceType, uint256 customerBalance, uint256 claims, uint256 createdAtTimestamp, uint256 updatedAtTimestamp) = CustomerStorage.getCustomer(customerId);
        uint256 claimsScaled = (claims++)*uint256(1e18);
        // emit Estimate(customerId, customerId);
        return  (address(this).balance / claimsScaled * customerBalance ) *1e16;
    }
    
    function makeClaim(uint256 amount) external returns (bool) {
        require(CustomerStorage.customers[msg.sender].customerId == msg.sender, "can only transfer to your account");
        CustomerStorage.customers[msg.sender].customerId.transfer(amount);
        CustomerStorage.customers[msg.sender].claims++;
        emit Claim(msg.sender, msg.sender, amount);
        return true;
    }
}

