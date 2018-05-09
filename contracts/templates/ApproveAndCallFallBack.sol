pragma solidity ^0.4.23;


contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokensAmount, address tokenAddr, bytes data) public;
}
