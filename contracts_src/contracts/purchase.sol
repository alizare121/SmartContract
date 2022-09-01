// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract Purchase {
    // state varibale
    uint public value;
    address payable seller;
    address payable buyyer;
    enum states {Created , Locked , Released , Inactived}
    states public currentState;

    // error function


    // modifier : 

    modifier condition (bool _condition) {
        require(_condition , "condition is not true!");
        _;
    }

    modifier onlySeller () {
        if(msg.sender != seller) 
        revert("only seller can call this function !!");
        _;
        
    }

    modifier onlyBuyyer () {
        if(msg.sender != buyyer) 
        revert("only buyyer can call this function !!");
        _;
        
    }

    modifier inState(states _state){
        if (currentState != _state)
        revert("invalid state");
        _;      
    }

    // events : 

    event Aborted();
    event PurchaseConfirmed();
    event ItemRecived();
    event SellerRefunded();


    // constructor :
    constructor ()
    payable{
        currentState = states.Created;
        seller = payable(msg.sender);
        value = msg.value/2;
        if(2*value !=msg.value)
        revert ("value is not even!! ");
    }


    // functions :

    function abort() public onlySeller inState(states.Created) {
        currentState = states.Inactived;
        seller.transfer(address(this).balance);
        emit Aborted();
    }

    function confirnPurchase() public payable inState(states.Created) condition(msg.value == (2*value)) {
        currentState = states.Locked;
        buyyer = payable(msg.sender);
        emit PurchaseConfirmed();
    }

    function confirmRecived() public onlyBuyyer inState(states.Locked) {
        currentState = states.Released;
        buyyer.transfer(value);
        emit ItemRecived();
    }

    function refundSeller() public onlySeller inState(states.Released) {
        currentState = states.Inactived;
        seller.transfer(3*value);
        emit SellerRefunded();
    }

    function _getBalance() public view returns(uint) {
        return address(this).balance;
    }
        


}