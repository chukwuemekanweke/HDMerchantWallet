pragma solidity ^0.6.4;

import "./Ownable.sol";
import "./MerchantWallet.sol";
import "./IMerchantWallet.sol";


contract Merchant is Ownable {


    //A map of a merchant wallet contract
    mapping(string => address) public merchantWallets;

   
    
    
    
    event CreateMerchantWalletEvent ( 
        string clientId,
        address merchantAddress,
        address merchantWalletAddress
    );
    

    constructor() public {
        owner = msg.sender;
        WalletAdmin = msg.sender;
    }
    
    
    function createMerchantWallet(string calldata clientId,address payable  merchantAddress) external onlyOwner returns(bool) {
        require( merchantWallets[clientId]==address(0) , " Wallet Merchant: Merchant Wallet Has Already Been Created");
        MerchantWallet merchantWallet = new MerchantWallet(WalletAdmin,merchantAddress);
        merchantWallets[clientId] = address(merchantWallet);
        emit CreateMerchantWalletEvent(clientId,merchantAddress,address(merchantWallet));
        return true;
    }
    
    
    
}