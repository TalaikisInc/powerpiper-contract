pragma solidity ^0.4.23;


contract Escrow {

    address public buyer;
    address public seller;
    address public arbiter;

    constructor(address _seller, address _arbiter) public payable {
        buyer = msg.sender;
        seller = _seller;
        arbiter = _arbiter;
    }

    function payoutSeller() public {
        if (msg.sender == buyer || msg.sender == arbiter) {
            seller.transfer(address(this).balance);
        }
    }

    function refundBuyer() public {
        if (msg.sender == seller || msg.sender == arbiter) {
            buyer.transfer(address(this).balance);
        }
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

}
