// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
library PriceConvertor{

    function getPrice() internal view returns(uint256){
        //abi sapolia network
        //address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        AggregatorV3Interface pricefeed= AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer, , ,)= pricefeed.latestRoundData();
        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000);
        // or (Both will do the same thing)
        // return uint256(answer * 1e10); // 1* 10 ** 10 == 10000000000
    }
    function getVersion() internal view returns(uint256){
        AggregatorV3Interface pricefeed= AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return pricefeed.version();
    }

    function getConversionRate(uint256 EthAmount)internal view returns(uint256){
        uint256 ethprice=getPrice();
        uint256 ethAmountinUSD=(ethprice*EthAmount)/1e18;
        return ethAmountinUSD;

    }
}