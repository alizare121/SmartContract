// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract Auction {
    // state varibales :
    address public  owner;
    address payable public beneficiary;
    uint public auctionEndTime;
    uint public heighestBid;
    address public heighestBidder;
    mapping(address => uint ) public pendingReturns;
    bool ended;

    // error funnctions : 

    // modifire : 
    modifier onlyOwner(){
        require(msg.sender == owner , "only owner can call this function");
        _;
    }

    // evennts : 
    event heighestBidIncreased(address heighestBidder , uint heighestBid);
    event auctionEnded(address winnner,uint amount);

    // constractor : 
    constructor(
        address payable _beneficiary,
        uint biddingTime
    ){
        owner = msg.sender;
        beneficiary = _beneficiary;
        auctionEndTime = block.timestamp + biddingTime;
    }


    // functions : 
    function bid() public  payable {
        if (block.timestamp > auctionEndTime)
        revert("auction has already ennded!");

        if (msg.value <= heighestBid)
        revert(" highestBid is not enough!");

        pendingReturns[heighestBidder] += heighestBid;

        heighestBid = msg.value;
        heighestBidder = msg.sender;

        emit heighestBidIncreased(heighestBidder, heighestBid);

    }

    function withdraw() public returns(bool){
        uint amount = pendingReturns[msg.sender];
        if(amount > 0) {
            pendingReturns[msg.sender] = 0;
            if(!payable(msg.sender).send(amount)){
                pendingReturns[msg.sender] =amount;
                return false;
            }
        }
        return true;
    }

    function auctionEnd() public onlyOwner {
        if (block.timestamp < auctionEndTime)
        revert("auction not yet ended !");

        if(ended)
        revert("auctionn end already called !");

        ended = true;
        beneficiary.transfer(heighestBid);
        emit auctionEnded(heighestBidder, heighestBid );
    }

    function _getBalance () public view returns (uint) {
        return address(this).balance;
    }

}