pragma solidity ^0.6.4;

import "./Ownable.sol";
import "./IERC20.sol";

contract ERC20Wallet is Ownable {
  
    IERC20 token;

    constructor (IERC20 _token, address payable _owner, address _switchWalletAdmin) public {
        owner = _owner;
        token = _token;
        switchWalletAdmin = _switchWalletAdmin;
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
    
    function sweepEthers() public returns (uint,address){
       uint etherBalance =  address(this).balance;
       require(etherBalance != 0, "ERC20Wallet: ether balance cannot be zero");
       owner.transfer(etherBalance);
       return (etherBalance,owner);
    }
    
    function tokenBalanceOf() public view  returns (uint amount){
        return token.balanceOf(address(this));
    }
    
     function tokenDecimals() public view  returns (uint8 decimals){
        return token.decimals();        
    }
    
    function etherBalanceOf() public view  returns (uint amount){
        return address(this).balance;
    }
}