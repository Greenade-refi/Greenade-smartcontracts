pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract AMM {
  using SafeERC20 for IERC20;

  IERC20 public stableCoin;
  IERC20 public token;

  constructor(address _stableCoin, address _token) {
    stableCoin = IERC20(_stableCoin);
    token = IERC20(_token);
  }

  function buyToken(uint256 amount) public {
    uint256 stableCoinAmount = amount * 1 ether;
    stableCoin.safeTransferFrom(msg.sender, address(this), stableCoinAmount);
    token.mint(msg.sender, amount);
  }

  function sellToken(uint256 amount) public {
    uint256 stableCoinAmount = amount * 1 ether;
    token.burn(msg.sender, amount);
    stableCoin.safeTransfer(msg.sender, stableCoinAmount);
  }
}

