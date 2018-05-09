pragma solidity ^0.4.23;

import "../templates/Ownable.sol";

contract Relay is Ownable {

    address public currentVersion;

    constructor(address initAddr) public {
        currentVersion = initAddr;
    }

    function changeContract(address newVersion) public onlyOwner {
        currentVersion = newVersion;
    }

    function () external {
        require(currentVersion.delegatecall(msg.data));
    }

}
