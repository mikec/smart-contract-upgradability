pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "./StorageStateful.sol";

contract TokenDelegate is StorageStateful {
  using SafeMath for uint256;

  function transfer(address to, uint256 value) public returns (bool) {
    require(to != address(0));
    require(value <= getBalance(msg.sender));

    subBalance(msg.sender, value);
    addBalance(to, value);
    return true;
  }

  function balanceOf(address owner) public view returns (uint256 balance) {
    return getBalance(owner);
  }

  function getBalance(address balanceHolder) public view returns (uint256) {
    return _storage.getUint(keccak256("balances", balanceHolder));
  }

  function totalSupply() public view returns (uint256) {
    return _storage.getUint("totalSupply");
  }

  function addSupply(uint256 amount) internal {
    _storage.setUint("totalSupply", totalSupply().add(amount));
  }

  function addBalance(address balanceHolder, uint256 amount) internal {
    setBalance(balanceHolder, getBalance(balanceHolder).add(amount));
  }

  function subBalance(address balanceHolder, uint256 amount) internal {
    setBalance(balanceHolder, getBalance(balanceHolder).sub(amount));
  }

  function setBalance(address balanceHolder, uint256 amount) internal {
    _storage.setUint(keccak256("balances", balanceHolder), amount);
  }

}
