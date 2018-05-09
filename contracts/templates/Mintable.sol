pragma solidity ^0.4.23;

import "./SafeMath.sol";
import "./ERC20.sol";
import "./Ownable.sol";


contract Mintable is ERC20, Ownable {

    bool public mintingFinished = false;

    event Mint(address indexed to, uint amount);
    event MintFinished();
    event DestroyTokens(address indexed _from, uint _value);

    modifier canMint() {
        require(!mintingFinished);
        _;
    }

    function mint(address _to, uint _amount) canMint public returns (bool) {
        _totalSupply = SafeMath.add(_totalSupply, _amount);
        balances[_to] = SafeMath.add(balances[_to], _amount);
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
    }

    function finishMinting() canMint onlyOwner public returns (bool) {
        mintingFinished = true;
        emit MintFinished();
        return true;
    }

    function destroyTokens(uint _amount) onlyOwner public {
        require(balances[msg.sender] >= _amount);

        balances[msg.sender] = SafeMath.sub(balances[msg.sender], _amount);
        _totalSupply = SafeMath.sub(_totalSupply, _amount);

        emit DestroyTokens(msg.sender, _amount);
    }

}
