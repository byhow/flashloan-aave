// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./aave/FlashLoanReceiverBaseV2.sol";
import "aave/interfaces/v2/ILendingPoolAddressesProviderV2.sol";
import "aave/interfaces/v2/ILendingPoolV2.sol";

contract FlashloanV2 is FlashLoanReceiverBaseV2, Withdrawable {
  constructor(address _addressProvider) FlashLoanReceiverBaseV2(_addressProvider) {}

  function flashloan(address _asset) public onlyOwner {
    bytes memory data = "";
    uint amount = 1 ether;

    address[] memory assets = new address[](1);
    assets[0] = _asset;
    
    uint256[] memory amounts = new uint256[](1);
    amounts[0] = amount;

    _flashloan(assets, amounts);
  }

  function _flashloan(address[] memory assets, uint256[] memory amounts) internal {
    address receiverAddress = address(this);
    address onBehalfOf = address(this);
    bytes memory params = "";
    uint16 referralCode = 0;
    uint256[] memory modes = new uint256[](assets.length);

    for (uint256 i = 0; i < assets.length; i++) {
      modes[i] = 0; // 0 being flashload options
    }

    LENDING_POOL.flashLoan(receiverAddress, assets, amounts, modes, onBehalfOf, params, referralCode);
  }
}