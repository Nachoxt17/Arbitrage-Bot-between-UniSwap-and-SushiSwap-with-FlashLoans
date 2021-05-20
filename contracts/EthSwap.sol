//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract EthSwap {
    string public name = "EthSwap Instant Exchange";
    address public exchangeSmartContract;
    address public fromToken;
    address public toToken;
    //+-Mapping to take account of the Buyers who have already purchased toTokens and are Waiting to Withdraw the from the S.C.:_
    mapping(address => uint256) internal Buyers;

    event TokensDeposited(
        address account,
        address fromToken,
        uint256 amount
    );

    event TokensWithdrawn(
        address account,
        address toToken,
        uint256 amount
    );

    constructor(address _exchangeSmartContract) {
        exchangeSmartContract = _exchangeSmartContract;
    }

    //+-Set the Address of the Smart Contracts of the Tokens that are going to be Swapped:_
    function setSwapPair(address _fromToken, address _toToken) public {//+-¿Será compatible que sean type "ERC20" y "address" al mismo tiempo?
        fromToken = _fromToken;
        toToken = _toToken;
    }

    //+-The User Deposits the Amount of fromTokens that is going to Swap:_
    function provide(uint256 _amount) public payable {
        //+-Checks that the User actually has that amount of Tokens in his/her Wallet:_
        //require(IERC20(fromToken).balanceOf(msg.sender) >= _amount);
        //+-(We don't need to implement this because the ERC-20 Standard already does it).

        //+-The user Deposits the Token in:_
        IERC20(fromToken).transferFrom(msg.sender, address(this), _amount);

        //+-We issue a notice that the fromTokens have been Deposited:_
        emit TokensDeposited(msg.sender, fromToken, _amount);
    }

    function  withdraw(uint256 _amount) public {//+-En esta función El Usuario debería poder retirar SOLO una Cantidad <= a Cantidad de toTokens que compró. 
        //+-Checks that the S.C. actually has that amount of Tokens Available:_
        require(IERC20(toToken).balanceOf(address(this)) >= _amount);

        //+-Checks that the User actually bought and is Owner of that amount of toTokens:_
        require(Buyers[msg.sender] <= _amount);

        //+-We issue a notice that the toTokens have been Withdrawn:_
        emit TokensWithdrawn(msg.sender, toToken, _amount);
    }

    /**function buyTokens(uint256 _amount) public payable {//+-¿Cómo sabemos a qué precio vender el Token?
        //+-Redemption rate = Number of Tokens they receive for 1 Ether:_
        //+-Calculate the number of Tokens to buy:_
        //uint256 tokenAmount = msg.value * rate;

        //+-Check the Liquidity Availabe in the Exchange and if it is enough to carry out the Transaction:_
        require(IERC20(toToken).balanceOf(address(this)) >= /**tokenAmount*/ //_amount); //+-"address(this)" is the Smart Contract Address.

        //+-Transfer Tokens to the user:_
        //IERC20(toToken).transfer(msg.sender, /**tokenAmount*/_amount);

        //+-Emit an Event:_
        //emit TokenPurchased(msg.sender, toToken, /**tokenAmount*/_amount/**, rate*/);
    //}
}
