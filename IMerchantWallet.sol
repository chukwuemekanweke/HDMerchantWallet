pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

/**
 * @dev Interface of the EtherWallet
 */
interface IMerchantWallet {
  
   
   function createEtherWallet(string calldata clientId) external returns (bool);
   
   function AddNewEtherWallet(string calldata clientId) external returns (bool);
   
   function sweepEthers(string calldata clientId) external returns (bool);
  
   function sweepEthers(address walletContractAddress) external returns(bool);
   
   function sweepTokens(address tokenAddress,  string calldata clientId) external returns (bool);
   
   function sweepTokens(address walletContractAddress, address tokenAddress) external returns (bool);
   
   function tokenBalanceOf(address walletContractAddress,address tokenAddress) external view  returns (uint);
   
   function tokenDecimals(address walletContractAddress,address tokenAddress) external view  returns (uint8);
   
   function etherBalanceOf(address walletContractAddress) external view  returns (uint);
   
   
  
    function getClients() external view returns (string[] memory);
    
    function getWalletsForClient(string calldata clientEmail) external view returns(address[] memory , address[] memory);
}