pragma solidity ^0.6.4;

import "./Ownable.sol";
import "./IERC20.sol";

contract EtherWallet is Ownable {

    event WalletEvent ( 
        address addr,
        string action,
        uint256 amount
    );



    constructor (address payable _owner, address _switchWalletAdmin) public {
        owner = _owner;
        switchWalletAdmin = _switchWalletAdmin;

    }
    
    receive() external payable { 


     }

    
    function sweepEthers() public returns (uint,address){
       uint etherBalance =  address(this).balance;
       require(etherBalance != 0, "ERC20Wallet: ether balance cannot be zero");
       owner.transfer(etherBalance);
       return (etherBalance,owner);
    }
    
    function etherBalanceOf() public view  returns (uint amount){
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