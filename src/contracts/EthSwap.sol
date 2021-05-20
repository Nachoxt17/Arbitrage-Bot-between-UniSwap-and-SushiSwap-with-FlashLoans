pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract EthSwap is IERC20 {
    string public name = "EthSwap Instant Exchange";
    uint256 public rate = 100;
    ERC20 public fromToken;
    ERC20 public toToken;

    event TokenPurchased(
        address account,
        address toToken,
        uint256 amount,
        /**uint256 rate*/
    );

    event TokenSold(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    );

    event TokensDeposited(
        address account,
        address fromToken,
        uint256 amount
    );

    constructor(ERC20 _fromToken, ERC20 _toToken) public {
        fromToken = fromToken;
        toToken = _toToken;
    }

    //+-Set the Address of the Smart Contracts of the Tokens that are going to be Swapped:_
    function setSwapPair(address _fromToken, address _toToken) public {//+-¿Será compatible que sean type "ERC20" y "address" al mismo tiempo?
        fromToken = _fromToken;
        toToken = _toToken;
    }

    function provide(uint256 _amount) public payable {
        require(fromToken.balanceOf(msg.sender) >= /**tokenAmount*/_amount);
        
        emit TokensDeposited(msg.sender, address(/**token*/fromToken), _amount);
    }

    function  withdraw(uint256 _amount) public {//+-En esta función El Usuario debería poder retirar SOLO una Cantidad <= a Cantidad de toTokens que compró. 

    }

    /**function buyTokens(uint256 _amount) public payable {//+-¿Cómo sabemos a qué precio vender el Token?
        //+-Redemption rate = Number of Tokens they receive for 1 Ether:_
        //+-Calculate the number of Tokens to buy:_
        //uint256 tokenAmount = msg.value * rate;

        //+-Check the Liquidity Availabe in the Exchange and if it is enough to carry out the Transaction:_
        require(toToken.balanceOf(address(this)) >= /**tokenAmount*/_amount); //+-"address(this)" is the Smart Contract Address.

        //+-Transfer Tokens to the user:_
        toToken.transfer(msg.sender, /**tokenAmount*/_amount);

        //+-Emit an Event:_
        //emit TokenPurchased(msg.sender, address(/**token*/toToken), /**tokenAmount*/_amount/**, rate*/);
    //}

    function buyTokens() public payable {
        //+-Redemption rate = Number of Tokens they receive for 1 Ether:_
        //+-Calculate the number of Tokens to buy:_
        uint256 tokenAmount = msg.value * rate;

        //+-Check the Liquidity Availabe in the Exchange and if it is enough to carry out the Transaction:_
        require(token.balanceOf(address(this)) >= tokenAmount); //+-"address(this)" is the Smart Contract Address.

        //+-Transfer Tokens to the user:_
        token.transfer(msg.sender, tokenAmount);

        //+-Emit an Event:_
        emit TokenPurchased(msg.sender, address(token), tokenAmount, rate);
    }

    function sellTokens(uint256 _amount) public {
        //+-Users can't sell more Tokens than they have:_
        require(token.balanceOf(msg.sender) >= _amount);

        //+-Calculate the amount of Ether to redeem:_
        uint256 etherAmount = _amount / rate;

        //+-Check the Liquidity Availabe in the Exchange and if it is enough to carry out the Transaction:_
        require(address(this).balance >= etherAmount);

        //+-Perform Sale:_
        token.transferFrom(msg.sender, address(this), _amount);
        msg.sender.transfer(etherAmount);

        //+-Emit a Sale Event:_
        emit TokenSold(msg.sender, address(token), _amount, rate);
    }
}
