// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract subcurrency {
//state varible :

address public minter ;
mapping(address=>uint) public balances;



// error function : 
error InsufficentBalance(uint requested, uint avaliable);


// modifires : 
    modifier onlyMinter(){
        require(msg.sender == minter, "only minter can call this function!!" );
        _;
    }

//events : 
event sent(address from , address to , uint amount);


//constructor : 

constructor () {
     minter = msg.sender;
}



//functions :
function mint(address receiver , uint amount) 
public 
onlyMinter{
    balances[receiver] += amount;
}

function send(address receiver , uint amount) public {
    if(amount > balances[msg.sender])
    revert InsufficentBalance(amount , balances[msg.sender]);

    balances[msg.sender] -= amount;
    balances[receiver] += amount;
    emit sent(msg.sender , receiver , amount);


}
}