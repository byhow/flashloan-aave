// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./aave/FlashLoanReceiverBaseV2.sol";
import "aave/interfaces/v2/ILendingPoolAddressesProviderV2.sol";
import "aave/interfaces/v2/ILendingPoolV2.sol";
import {SafeMath} from "openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

contract FlashloanV2 is FlashLoanReceiverBaseV2, Withdrawable {
    // scoping: https://docs.soliditylang.org/en/v0.8.13/070-breaking-changes.html#functions-and-events
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    constructor(address _addressProvider) FlashLoanReceiverBaseV2(_addressProvider) {}

    function flashloan(address _asset) public onlyOwner {
        bytes memory data = "";
        uint256 amount = 1 ether;

        address[] memory assets = new address[](1);
        assets[0] = _asset;

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = amount;

        _flashloan(assets, amounts);
    }

    /*
     * where the functionality will be ran
     *
     */
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // arbitrage with `assets`

        // need to apporve LP to get funds back; if it is not able to get the funds, it will
        // null out all the txns ^
        for (uint256 i = 0; i < assets.length; i++) {
            uint256 amountOwing = amounts[i].add(premiums[i]);
            IERC20(assets[i]).approve(address(LENDING_POOL), amountOwing);
        }

        return true;
    }

    function _flashloan(address[] memory assets, uint256[] memory amounts) internal {
        address receiverAddress = address(this); // send it back
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
