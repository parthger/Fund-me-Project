// SPDX-License-Identifier: MIT
//get funds from user
//withdraw funds
//Set a minimum funding value in usd
pragma solidity ^0.8.8;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "PriceConvertor.sol";
error NotOwner();

contract FundMe{

    using PriceConvertor for uint256; // ye humne isliye use krra bcz hum library of priceConvertor se function laa rhe h
    uint256 public constant miniUST=10*1e18;
    address public immutable i_owner ;


    address[] public funders;// it willadd adress to array

    mapping(address=>uint256) public AdressTOAmountFunded;
    //mapping of adress to amount send by people

    constructor(){
        i_owner=msg.sender;
    }

    function fund() public payable {
       require( msg.value.getConversionRate() >= miniUST,"Didint send enough");
       funders.push(msg.sender);
       AdressTOAmountFunded[msg.sender] = msg.value;
    
    }

    function withdraw() public onlyOwner {
        for(uint256 funder=0;funder<funders.length;funder++){
            address funderPerson=funders[funder];
            AdressTOAmountFunded[funderPerson]=0;
        }

        //reset the array 
        funders=new address[](0);
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
    modifier onlyOwner {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }
    

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    
}