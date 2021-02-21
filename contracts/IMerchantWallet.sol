pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

/**
 * @dev Interface of the EtherWallet
 */
interface IMerchantWallet {
  
   
   function createBNBWallet(string calldata clientId) external returns (bool);
   
   function AddNewBNBWallet(string calldata clientId) external returns (bool);
   
   function sweepBNB(string calldata clientId) external returns (bool);
  
   function sweepBNB(address walletContractAddress) external returns(bool);
   
   function sweepTokens(address tokenAddress,  string calldata clientId) external returns (bool);
   
   function sweepTokens(address walletContractAddress, address tokenAddress) external returns (bool);
   
   function tokenBalanceOf(address walletContractAddress,address tokenAddress) external view  returns (uint);
   
   function tokenDecimals(address walletContractAddress,address tokenAddress) external view  returns (uint8);
   
   function BNBBalanceOf(address walletContractAddress) external view  returns (uint);
   
   
  
    function getClients() external view returns (string[] memory);
    
    function getWalletsForClient(string calldata clientEmail) external view returns(address[] memory , address[] memory);
}