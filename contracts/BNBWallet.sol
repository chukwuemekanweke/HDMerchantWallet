pragma solidity ^0.6.4;

import "./Ownable.sol";
import "./IERC20.sol";

contract BNBWallet is Ownable {

    event WalletEvent ( 
        address addr,
        string action,
        uint256 amount
    );



    constructor (address payable _owner, address _WalletAdmin) public {
        owner = _owner;
        WalletAdmin = _WalletAdmin;

    }
   

    
    function sweepBNB() public returns (uint,address){
       uint BNBBalance =  address(this).balance;
       require(BNBBalance != 0, "ERC20Wallet: ether balance cannot be zero");
       owner.transfer(BNBBalance);
       return (BNBBalance,owner);
    }
    
    function BNBBalanceOf() public view  returns (uint amount){
        return address(this).balance;
    }
    
    
    
    
     function sweepTokens(address tokenAddress) external returns (uint,address,address){
        IERC20 token = IERC20(tokenAddress);
        uint tokenBalance = token.balanceOf(address(this));
        require(tokenBalance != 0, "ERC20Wallet: token balance cannot be zero");
        token.transfer(owner, tokenBalance);
       return (tokenBalance,address(this),owner);
    }
    
    
    function tokenBalanceOf(address tokenAddress) external view  returns (uint amount){
        IERC20 token = IERC20(tokenAddress);
        return token.balanceOf(address(this));
    }
    
     function tokenDecimals(address tokenAddress) public view  returns (uint8 decimals){
        IERC20 token = IERC20(tokenAddress);
        return token.decimals();
    }
}