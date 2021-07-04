+-YOU NEED TO MODIFICATE THE "index.js" FILE IN A WAY THAT IT MONITORS THE DIFFERENT PRICES OF THE SAME TOKENS IN DIFFERENT DECENTRALIZED EXCHANGES SO IT TRIGGERS THE "ArbitrageFlashLoaner.sol" S.C. AND PERFORMS THE ARBITRAGE TRADE AUTOMATICALLY.

+-For Testing the Successfully working "index.js" (when you have it) you should Test it with the S.C. Deployed and Verified in the Ropsten Ethereum TestNet:\_
https://ropsten.etherscan.io/address/0x455835f93a2eab153b5f5d6f387c49aaa8ab9007

+You can get Ropsten Test Ether Here:\_
https://faucet.dimensions.network/

+-Arbitrage Tutorials:\_ https://blog.infura.io/build-a-flash-loan-arbitrage-bot-on-infura-part-i/
https://blog.infura.io/build-a-flash-loan-arbitrage-bot-on-infura-part-ii/

## +-Quick Project start:\_

+-(1)-The first things you need to do are cloning this repository and installing its
dependencies:

```sh
npm install
```

+-(2-A)-Once installed, open a 1st Terminal and let's run Ropsten Ethereum Test Network(https://hardhat.org/tutorial/deploying-to-a-live-network.html):\_

```sh
npx hardhat run scripts/deploy.js --network ropsten
```

+-(2-B)-Or you can also Test your Project Cloning the Ethereum Main Network in your Local Hardhat Node:\_
https://hardhat.org/guides/mainnet-forking.html

```sh
npx hardhat node
```

+-(3)-Then, you can run this to Test the Script "index.js" part of the Bot:\_

```sh
npm run start
```

> Note: There's [an issue in `ganache-core`](https://github.com/trufflesuite/ganache-core/issues/650) that can make the `npm install` step fail.
>
> If you see `npm ERR! code ENOLOCAL`, try running `npm ci` instead of `npm install`.

Open [http://localhost:3000/](http://localhost:3000/) to see your Dapp. You will
need to have [Metamask](https://metamask.io) installed and listening to
`localhost 8545`.

## User Guide:\_

You can find detailed instructions on using this repository and many tips in [its documentation](https://hardhat.org/tutorial).

- [Setting up the environment](https://hardhat.org/tutorial/setting-up-the-environment.html)
- [Testing with Hardhat, Mocha and Waffle](https://hardhat.org/tutorial/testing-contracts.html)
- [Hardhat's full documentation](https://hardhat.org/getting-started/)

For a complete introduction to Hardhat, refer to [this guide](https://hardhat.org/getting-started/#overview).
