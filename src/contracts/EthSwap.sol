pragma solidity ^0.5.0;

import "./Token.sol";

contract EthSwap {
    string public name = "EthSwap Instant Exchange";
    Token public token;
    uint256 public rate = 100;

    event TokenPurchased(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    );

    event TokenSold(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    );

    constructor(Token _token) public {
        token = _token;
    }

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
