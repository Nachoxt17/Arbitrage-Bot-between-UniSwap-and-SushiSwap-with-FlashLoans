//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.2;

import 'hardhat/console.sol';

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol';

library SafeMath {

    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, 'add: +');

        return c;
    }

    function add(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, errorMessage);

        return c;
    }

    function sub(uint a, uint b) internal pure returns (uint) {
        return sub(a, b, 'sub: -');
    }

    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }

    function mul(uint a, uint b) internal pure returns (uint) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, 'mul: *');

        return c;
    }

    function mul(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, errorMessage);

        return c;
    }

    function div(uint a, uint b) internal pure returns (uint) {
        return div(a, b, 'div: /');
    }

    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint a, uint b) internal pure returns (uint) {
        return mod(a, b, 'mod: %');
    }

    function mod(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract EthSwap {

    using SafeMath for uint;

    string public name = "EthSwap Instant Exchange";
    address public exchangeSmartContract;
    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public fromToken;
    address public toToken;
    //+-Mapping to take account of the Buyers who have already purchased toTokens and are Waiting to Withdraw the from the S.C.:_
    mapping(address => uint) internal Buyers;

    event TokensDeposited(
        address account,
        address fromToken,
        uint amount
    );

    event TokensWithdrawn(
        address account,
        address toToken,
        uint amount
    );

    constructor(address _exchangeSmartContract) public {
        exchangeSmartContract = _exchangeSmartContract;
    }

    //+-Set the Address of the Smart Contracts of the Tokens that are going to be Swapped:_
    function setSwapPair(address _fromToken, address _toToken) public {//+-¿Será compatible que sean type "ERC20" y "address" al mismo tiempo?
        fromToken = _fromToken;
        toToken = _toToken;
    }

    //+-The User Deposits the Amount of fromTokens that is going to Swap:_
    function provide(uint _amount) public payable {
        //+-Checks that the User actually has that amount of Tokens in his/her Wallet:_
        //require(IERC20(fromToken).balanceOf(msg.sender) >= _amount);
        //+-(We don't need to implement this because the ERC-20 Standard already does it).

        //+-The User Deposits the Token in the S.C.:_
        IERC20(fromToken).transferFrom(msg.sender, address(this), _amount);

        //+-Now that our contract owns fromTokens, we need to approve the UniSwapRouter to Withdraw them:_
        IERC20(fromToken).approve(UNISWAP_V2_ROUTER, _amount);

        //+-We issue a notice that the fromTokens have been Deposited:_
        emit TokensDeposited(msg.sender, fromToken, _amount);
    }

    function swap(uint256 _fromTokensAmount) public {
        //+-Tenga una función swap(uint256 _amount) que use los provided fromTokens previamente Swappearlos por toTokens en UniSwapV2.
        //+-We check that the UniSwapRouter actually is able to Withdraw the fromTokens for performing the Swap:_
        require(IERC20(fromToken).approve(UNISWAP_V2_ROUTER, _fromTokensAmount));

        //+-"path" is a List of Token Addresses that we want this Trade to Happen:_
        address[] memory path;
        path = new address[](2);
        path[0] = fromToken;
        //+-(We could have an "IntermediateToken" here just in case it would be a better deal to first Swap "fromToken" to "IntermediateToken" and then Swap it for "toToken").
        path[1] = toToken;

        //+-The S.C. performs the Swap with UniSwapV2Router:_
        IUniswapV2Router01(UNISWAP_V2_ROUTER).swapExactTokensForTokens(_fromTokensAmount, 0, path, address(this), block.timestamp);

        //+-If the Swap with UniSwapV2Router was Successful, when the "toTokens" are Deposited in the Exchange S.C. we assign that amount of "toTokens" to the Buyer:_
        //require(IUniswapV2Router01(address(IUniswapV2Router01)).swapExactTokensForTokens(_fromTokensAmount, 0, path, address(this), block.timestamp));
        //Buyers[msg.sender] = _toTokensAmount;
    }

    function  withdraw(uint256 _amount) public {//+-En esta función El Usuario debería poder retirar SOLO una Cantidad <= a Cantidad de toTokens que compró. 
        //+-Checks that the S.C. actually has that amount of Tokens Available:_
        require(IERC20(toToken).balanceOf(address(this)) >= _amount);

        //+-Checks that the User actually bought and is Owner of that amount of toTokens:_
        require(Buyers[msg.sender] <= _amount);

        //+-The User Withdraws the Token from the S.C.:_
        IERC20(toToken).transferFrom(address(this), msg.sender, _amount);

        //+-We discount the from the List the "toTokens" that the User has in the S.C.:_
        Buyers[msg.sender] = Buyers[msg.sender] - _amount;

        //+-We issue a notice that the toTokens have been Withdrawn:_
        emit TokensWithdrawn(msg.sender, toToken, _amount);
    }

    /**function buyTokens(uint256 _amount) public payable {//+-¿Cómo sabemos a qué precio vender el Token?
        //+-Redemption rate = Number of Tokens they receive for 1 Ether:_
        //+-Calculate the number of Tokens to buy:_
        //uint256 tokenAmount = msg.value * rate;

        //+-Check the Liquidity Availabe in the Exchange and if it is enough to carry out the Transaction:_
        require(IERC20(toToken).balanceOf(address(this)) >= /**tokenAmount*/ //_amount); //+-"address(this)" is the Smart Contract Address.

        //+-Transfer Tokens to the User:_
        //IERC20(toToken).transfer(msg.sender, /**tokenAmount*/_amount);

        //+-Emit an Event:_
        //emit TokenPurchased(msg.sender, toToken, /**tokenAmount*/_amount/**, rate*/);
    //}
}
