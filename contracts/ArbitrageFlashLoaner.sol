//SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;

import "./UniswapV2Library.sol";
import "./interfaces/IUniswapV2Router02.sol";
import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IUniswapV2Factory.sol";
import "./interfaces/IERC20.sol";

contract ArbitrageFlashLoaner {
    //+-We connect the S.C. with the UniSwap(Factory) tools and Info:_
    address public factory;
    uint256 constant deadline = 10 days;
    //+-We connect the S.C. with the SushiSwap(Factory) tools and Info(Its Code is very similar to the Code of UniSwap, for that reason we use the UniSwap Interface):_
    IUniswapV2Router02 public sushiRouter;

    constructor(
        address _factory,
        address _sushiRouter
    ) public {
        factory = _factory;
        sushiRouter = IUniswapV2Router02(_sushiRouter);
    }

    //+-The Trader has to monitor Price Differences between UniSwap and SushiSwap and when finds one, Call This Function:_
    function startArbitrage(
        address token0, /**+-Asset Token S.Contract Address. Ex:_ WBTC.*/
        address token1, /**+-StableCoin Token S.Contract Address. Ex:_ DAI.*/
        uint256 amount0, /**+-ZERO Amount of the Asset "token0" that we want to use in the Transaction.*/
        uint256 amount1 /**+-Amount of Money in "token1" that we are going to borrow with a FlashLoan.*/
    ) external {
        //+-It looks for the Coin Pair in UniSwap:_
        address pairAddress =
            IUniswapV2Factory(factory).getPair(token0, token1);
        //+-You have to make sure that the Coin Pair actually exists in UniSwap:_
        require(pairAddress != address(0), "This pool does not exist");
        //+-Initiates the FlashLoan(To Better Understanding, see UniSwap A.P.I. Documentation):_
        IUniswapV2Pair(pairAddress).swap(
            amount0,
            amount1,
            address(this), /**+-Address where we are going to receive the Token that we borrowed(This S.C.).*/
            bytes("not empty") /**+-Makes sure that this is not empty so it will Trigger the FlashLoan.(IGNORE THIS).*/
        );
    }

    function uniswapV2Call(
        address _sender,
        uint256 _amount0,
        uint256 _amount1,
        bytes calldata _data /**+-Makes sure that this is not empty so it will Trigger the FlashLoan.(IGNORE THIS).*/
    ) external {
        //+-Array of the 2 Tokens Addresses:_
        address[] memory path = new address[](2);
        //+-Ammount of Token that we borrowed:_
        uint256 amountToken = _amount0 == 0 ? _amount1 : _amount0;

        //+-Addresses pf the 2 Tokens in the Liquidity Pool of UniSwap:_
        address token0 = IUniswapV2Pair(msg.sender).token0();
        address token1 = IUniswapV2Pair(msg.sender).token1();

        //+-Makes sure that the Call comes from one of the Pair S.C.s of UniSwap:_
        require(
            msg.sender == UniswapV2Library.pairFor(factory, token0, token1),
            "Unauthorized"
        );
        //+-Makes sure that ONE of the Amounts is == ZERO:_
        require(_amount0 == 0 || _amount1 == 0);

        //+-Defines the Direction of the Trade (From Token0 to Token1 or vice versa):_
        path[0] = _amount0 == 0 ? token1 : token0;
        path[1] = _amount0 == 0 ? token0 : token1;

        //+-Pointer to the Token that we are going to Sell on SushiSwap:_
        IERC20 token = IERC20(_amount0 == 0 ? token1 : token0);

        //+-We Allow the Router of SushiSwap to Spendig all our Tokens that are Neccesary to doing the Trade:_
        token.approve(address(sushiRouter), amountToken);

        //+-We Calculate the Ammount of Tokens that we will need to reimburse to the FlashLoan in UniSwap:_
        uint256 amountRequired =
            UniswapV2Library.getAmountsIn(factory, amountToken, path)[0];
        //+-We Sell in SushiSwap the Tokens we Borrowed from UniSwap:_
        uint256 amountReceived =
            sushiRouter.swapExactTokensForTokens(
                amountToken, /**+-Ammount of Tokens we are going to Sell.*/
                amountRequired, /**+-Minimum Ammount of Tokens that we expect to receive in exchange for our Tokens.*/
                path, /**+-We tell SushiSwap what Token to Sell and what Token to Buy.*/
                msg.sender, /**+-Address of this S.C. where the Output Tokens are going to be received.*/
                deadline /**+-Time Limit after which an order will be rejected by SushiSwap(It is mainly useful if you send an Order directly from your wallet).*/
            )[1];

        //+-Pointer to the other Token that we get as an output from SushiSwap:_
        IERC20 otherToken = IERC20(_amount0 == 0 ? token0 : token1);
        //+-A portion of these Tokens are going to be used for reimburse the FlashLoan of UniSwap:_
        otherToken.transfer(msg.sender, amountRequired);
        //+-We take our Profit:_
        otherToken.transfer(
            tx.origin, /**Address that initiated the whole transaction(Our Wallet or a Script that we used to Monitor the Prices).*/
            amountReceived - amountRequired
        );
    }
}
