// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    using SafeMathChainlink for uint256;
    mapping(address => uint256) public addressToAmountFounded;
    address public owner;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) public payable {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function fund() public payable {
        // 50
        uint256 minimumUSD = 1 * 10**18;
        require(
            getConversionRate(msg.value) >= minimumUSD,
            "You eth is need be to be more"
        );

        addressToAmountFounded[msg.sender] += msg.value;
        // what is the eth -> usd conversion rate
        // Oracles
    }

    function getVersion() public view returns (uint256) {
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer * 1000000000); // convert to wei

        //4291,07566397
    }

    // 100000000
    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
        // 0.000000429107566397 USD
    }

    function getEntranceFee() public view returns (uint256) {
        // Mininmum USD
        uint256 minimumUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        return (minimumUSD * precision) / price;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function witdraw() public payable onlyOwner {
        msg.sender.transfer(address(this).balance);
    }
}
