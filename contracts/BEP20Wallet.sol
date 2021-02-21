pragma solidity ^0.6.4;

import "./Ownable.sol";
import "./IERC20.sol";

contract BEP20Wallet is Ownable {
  
    IERC20 token;

    constructor (IERC20 _token, address payable _owner, address _WalletAdmin) public {
        owner = _owner;
        token = _token;
        WalletAdmin = _WalletAdmin;
    }
    
    /*
    
    receive() external payable { 


     }
     
     */


    function sweepTokens() public returns (uint,address,address){
        uint tokenBalance = token.balanceOf(address(this));
        require(tokenBalance != 0, "ERC20Wallet: token balance cannot be zero");
        token.transfer(owner, tokenBalance);
       return (tokenBalance,address(this),owner);
    }
    
    function sweepBNB() public returns (uint,address){
       uint BNBBalance =  address(this).balance;
       require(BNBBalance != 0, "ERC20Wallet: ether balance cannot be zero");
       owner.transfer(BNBBalance);
       return (BNBBalance,owner);
    }
    
    function tokenBalanceOf() public view  returns (uint amount){
        return token.balanceOf(address(this));
    }
    
     function tokenDecimals() public view  returns (uint8 decimals){
        return token.decimals();        
    }
    
    function BNBBalanceOf() public view  returns (uint amount){
        return address(this).balance;
    }
}