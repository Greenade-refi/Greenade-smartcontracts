pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CarbonCreditToken is ERC20 {
  constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

  // Mint Carbon Credit Token
  function mint(address to, uint256 amount) public {
    _mint(to, amount);
  }

  // Burn Carbon Credit Token
  function burn(address from, uint256 amount) public {
    _burn(from, amount);
  }
}


