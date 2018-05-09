pragma solidity ^0.4.23;


contract Console {

    event LogUint(string, uint);
    event LogInt(string, int);
    event LogBytes(string, bytes);
    event LogBytes32(string, bytes32);
    event LogAddress(string, address);
    event LogBool(string, bool);

    function log(string s, uint x) public {
        emit LogUint(s, x);
    }
    
    function log(string s, int x) public {
        emit LogInt(s, x);
    }
    
    function log(string s, bytes x) public {
        emit LogBytes(s, x);
    }
    
    function log(string s, bytes32 x) public {
        emit LogBytes32(s, x);
    }

    function log(string s, address x) public {
        emit LogAddress(s, x);
    }

    function log(string s, bool x) public {
        emit LogBool(s, x);
    }

}
