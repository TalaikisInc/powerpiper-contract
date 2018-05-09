pragma solidity ^0.4.23;

import "../states/ICO.sol";
import "./Ownable.sol";


contract MigratePreICO is Ownable {

    function migrate(address[] _recipients) public view botOnly {
        for(uint i = 0; i < _recipients.length; i++) {
            // doMigration(_investors[i]);
        }

    }

}
