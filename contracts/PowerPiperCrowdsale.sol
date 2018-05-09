pragma solidity ^0.4.23;

import "./templates/Ownable.sol";
import "./templates/Basic.sol";
import "./templates/ApproveAndCallFallBack.sol";
import "./templates/SafeMath.sol";
import "./templates/ICOManagement.sol";

contract PowerPiperCrowdsale is Basic, Ownable, ICOManagement {

    bytes32 public symbol;
    bytes32 public  tokenName;
    uint8 public decimals;
    uint public startDate;
    uint public bonusEnds;
    uint public endDate;
    uint public rate;
    uint public bonusRate;
    uint public cap;
    uint public weiRaised;
    bool private reentrancyLock = false;
    mapping(address => bool) internal whitelist;

    modifier isWhitelisted(address _beneficiary) {
        require(whitelist[_beneficiary]);
        _;
    }

    constructor() public {
        symbol = "PWP";
        tokenName = "PowerPiperToken";
        decimals = 18;
        startDate = now + 200 seconds;
        bonusEnds = now + 5 weeks;
        endDate = now + 52 weeks;
        rate = 5000;
        cap = 10000 ether;
        bonusRate = 6000;
    }

    function hasClosed() public view returns (bool) {
        return now > endDate;
    }

    function capReached() public view returns (bool) {
        return weiRaised >= cap;
    }

    function approveAndCall(address _spender, uint _tokens, bytes _data) public returns (bool success) {
        allowed[msg.sender][_spender] = _tokens;
        emit Approval(msg.sender, _spender, _tokens);
        ApproveAndCallFallBack(_spender).receiveApproval(msg.sender, _tokens, this, _data);
        return true;
    }

    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
        allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
        uint oldValue = allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            allowed[msg.sender][_spender] = 0;
        } else {
            allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
        }
        emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
        return true;
    }

    function () public payable { // isWhitelisted(_beneficiary) - disabled temporarily
        uint256 _weiAmount = msg.value;
        address _beneficiary = msg.sender;
        require(_beneficiary != address(0));
        require(_weiAmount != 0);
        require(now >= startDate && now <= endDate);
        require(SafeMath.add(weiRaised, _weiAmount) <= cap);

        uint tokens;

        if (now <= bonusEnds) {
            tokens = SafeMath.mul(msg.value, bonusRate);
        } else {
            tokens = SafeMath.mul(msg.value, rate);
        }

        require(!reentrancyLock);
        reentrancyLock = true;
        balances[_beneficiary] = SafeMath.add(balances[_beneficiary], tokens);
        _totalSupply = SafeMath.add(_totalSupply, tokens);
        emit Transfer(address(0), _beneficiary, tokens);
        owner.transfer(_weiAmount);
        weiRaised = SafeMath.add(weiRaised, _weiAmount);
        reentrancyLock = false;
    }

    function safeTransfer(address _to, uint256 _tokens) internal {
        assert(transfer(_to, _tokens));
    }

    function reclaimToken(address _tokenOwner) public onlyOwner returns (bool) {
        uint256 balance = balanceOf(_tokenOwner);
        safeTransfer(owner, balance);
        return true;
    }

    function addToWhitelist(address _beneficiary) public onlyOwner {
        whitelist[_beneficiary] = true;
    }

    function addManyToWhitelist(address[] _beneficiaries) public onlyOwner {
        for (uint256 i = 0; i < _beneficiaries.length; i++) {
            whitelist[_beneficiaries[i]] = true;
        }
    }

    function removeFromWhitelist(address _beneficiary) public onlyOwner {
        whitelist[_beneficiary] = false;
    }

    function getWhitelistStatus(address _beneficiary) public view onlyOwner returns (bool) {
        return whitelist[_beneficiary];
    }

}
