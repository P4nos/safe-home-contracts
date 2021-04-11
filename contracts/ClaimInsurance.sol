// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

 import "https://raw.githubusercontent.com/smartcontractkit/chainlink/master/evm-contracts/src/v0.6/ChainlinkClient.sol";


contract ClaimInsurance is ChainlinkClient {

    event ReceivedEvent(bytes32 indexed requestId, bytes32 createdAt);
    bytes32 public createdAt;    
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;


    /**
     * Network: Kovan
     * Fee: 0.1 LINK
     */
    constructor() public {
        setPublicChainlinkToken();
        oracle = 0x56dd6586DB0D08c6Ce7B2f2805af28616E082455;
        jobId = "c128fbb0175442c8ba828040fdd1a25e";
        fee = 0.1 * 10 ** 18; // 0.1 LINK
    }

    function requestEventFromProvider(string memory urlParams) public returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        string memory mainURL = "https://api.staging.minut.com/v5/events?";
        
        bytes memory b = abi.encodePacked(mainURL);
        b = abi.encodePacked(b, urlParams);
        string memory url = string(b);

        // Set the URL to perform the GET request on
        request.add("get", url);
        request.add("path", "events.0.created_at");
        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }
    
    /**
     * Receive the response in the form of uint256
     */ 
    function fulfill(bytes32 _requestId, bytes32 _createdAt) public recordChainlinkFulfillment(_requestId) {
      createdAt = _createdAt;
    
      emit ReceivedEvent(_requestId, _createdAt);
    }
}