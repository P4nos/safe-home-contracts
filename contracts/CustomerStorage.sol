// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract CustomerStorage {
    enum InsuranceType {Simple, Extended}
    
    struct  Insurance  {
        InsuranceType insuranceType;
        address payable customerId;
        uint256 depositAmmount;
        uint256 claims;
        uint256 createdAt;
        uint256 lastUpdatedAt;
        bool isNewEntity;
    }

    mapping(address => Insurance) public customers;


    function storeCustomer(address payable newCustomerId, uint256 ammount, InsuranceType insuranceType) public {
        // check if user already exists
        require(customers[newCustomerId].isNewEntity == false, "user already exists");
        uint256 nowTimestamp = block.timestamp;
        Insurance storage i = customers[newCustomerId];
        i.depositAmmount += ammount;
        i.insuranceType = insuranceType;
        i.customerId = newCustomerId;
        i.createdAt = nowTimestamp;
        i.claims = 0;
        i.lastUpdatedAt = nowTimestamp;
        i.isNewEntity = true;
    }
  
    function getCustomer(address customerId) view public returns (InsuranceType, uint256, uint256, uint256, uint256) {
        return (customers[customerId].insuranceType, customers[customerId].depositAmmount, customers[customerId].claims, customers[customerId].createdAt, customers[customerId].lastUpdatedAt);
    }
  
    function updateCustomerDeposit(address customerId, uint256 ammount) public returns (uint256, uint256) {
        require(CustomerStorage.customers[customerId].customerId == customerId);

        uint256 nowTimestamp = block.timestamp;
        Insurance storage i = customers[customerId];
        i.depositAmmount += ammount;
        i.lastUpdatedAt = nowTimestamp;
        return (i.depositAmmount, i.lastUpdatedAt);
    }
}