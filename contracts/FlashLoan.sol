//SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@aave/protocol-v2/contracts/flashloan/base/FlashLoanReceiverBase.sol";
import "@aave/protocol-v2/contracts/interfaces/ILendingPool.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";

contract FlashLoan is FlashLoanReceiverBase{

	address payable owner; 
    IUniswapV2Pair public SWAP;
	address public t1;
	address public t2;

	constructor(address _addrProvider) FlashLoanReceiverBase(_addrProvider) public {
		owner = payable(msg.sender);		
	}

	function _flashLoan(address[] memory _assets, uint256[] memory _amount) internal {

		address payable receiver = payable(address(this));
		address onBehalfOf = address(this);
		bytes memory params = "";
		uint16 referralCode = 0;
		uint256[] memory modes = new uint256[](_assets.length);
		for(uint i = 0; i <= _assets.length; i++){
			modes[i] = 0;
		}

		LENDING_POOL.flashLoan(
			receiver,
			_assets,
			_amount,
			modes,
			onBehalfOf,
			params,
			referralCode
		);
	}

	function flashLoan(address _asset, uint256 _amount) public {		
		address[] memory assets = new address[](1);
		uint256[] memory amounts = new uint256[](1);
		assets[0] = _asset;
		amounts[0] = _amount;
		_flashLoan(assets, amounts);
	}

	function init(address _t1, address _t2) public  {
		t1 = _t1;
		t2 = _t2;
	}

	function executeOperation (
		address[] calldata assets,
		uint256[] calldata amount,
		uint256[] calldata premiums,
		address initiator,
		bytes calldata params
	) external override returns(bool) {
		SWAP.initialize(t1, t2);
		SWAP.swap(
			amount[0],
			amount[0],
			address(this),
			""
		);

		for(uint i = 0; i <= assets.length; i++){
			uint debt = amount[i] + premiums[i];			
			IERC20(assets[i]).approve(address(LENDING_POOL), debt);		
		}

		return true;
	} 

	 function withdrawProceeds(address _addr) external payable {
	 	if (msg.sender != owner) { revert(); }
	 	(bool success,) = _addr.call{value: address(this).balance}("");
	 	require(success);	 	
	 }
}