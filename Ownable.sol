pragma solidity ^0.6.4;


/*
 * Ownable
 *
 * Base contract with an owner.
 * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
 */
contract Ownable {
  address payable public owner;
  address public switchWalletAdmin;



  modifier onlyOwner() {
    if (msg.sender == owner)
      _;
  }
  
  modifier onlySwitchWalletOrOwner() {
    if (msg.sender == owner || msg.sender == switchWalletAdmin)
      _;
  }
  
  

  function transferOwnership( address payable newOwner) public onlySwitchWalletOrOwner {
    if (newOwner != address(0)) owner = newOwner;
  }

}