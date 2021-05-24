//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import 'hardhat/console.sol';

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

contract BaseSmartContract {

    using SafeMath for uint;

    string public name = "SampleSmartContract";
    address public SampleSmartContract;
    address private constant UNISWAP_V2_ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    constructor(address _SampleSmartContract) public {
        SampleSmartContract = _SampleSmartContract;
    }
}
