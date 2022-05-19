// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./aave/FlashLoanReceiverBaseV2.sol";
import "aave/interfaces/v2/ILendingPoolAddressesProviderV2.sol";
import "aave/interfaces/v2/ILendingPoolV2.sol";

contract FlashloadV2 is IFlashLoanReceiverV2, Withdrawable {
  
}