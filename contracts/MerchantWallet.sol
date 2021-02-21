pragma solidity ^0.6.4;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

import "./IBNBWallet.sol";
import "./BNBWallet.sol";

import "./IERC20.sol";

contract MerchantWallet is Ownable {

    string[] public clients;

   
    //A map of a user's ether wallets
    mapping(string => address[]) public bnbContractWallets;
    mapping(address => string) public contractWalletOwners;


     
   

    
    
    event WalletCreationEvent ( 
        address contractWalletAddress,
        address merchantWalletAddress,
        string clientId
    );
    
    
    event TokenSweepEvent (
        uint256 amount,
        address tokenAddress,
        address destinationAddress,
        address merchantWalletAddress,
        address contractWalletAddress,
        string clientId
    );
    
    event BNBSweepEvent ( 
        uint256 amount,
        address destinationAddress,
        address merchantWalletAddress,
        address contractWalletAddress,
        string clientId

    );
    

    constructor(address _walletAdmin,address payable _owner) public {
        owner = _owner;
        WalletAdmin = _walletAdmin;
    }

    function createBNBWallet(string calldata clientId) onlyOwner external returns (bool) {
        require(bnbContractWallets[clientId].length == 0, "MerchantWallet: Ether wallet exists");
        createWallet(clientId);
        clients.push(clientId);
        return true;
    }

    function addNewBNBWallet(string calldata clientId) onlyOwner external returns (bool) {
        createWallet(clientId);
        return true;
    }
    
    
    function createWallet(string memory clientId) internal {
        BNBWallet bnbWallet = new BNBWallet(owner,WalletAdmin);
        bnbContractWallets[clientId].push(address(bnbWallet));
        contractWalletOwners[address(bnbWallet)] = clientId;
        emit WalletCreationEvent(address(bnbWallet),address(this), clientId);
    }
    
    
     function sweepBNB(string calldata clientId)onlyOwner external returns (bool){
         
        require(bnbContractWallets[clientId].length > 0, "MerchantWallet: bnb wallet does not exist");
         address[] memory walletContractAddresses = bnbContractWallets[clientId];
        for(uint i = 0; i < walletContractAddresses.length; ++i ){
           
            address walletContractAddress =  walletContractAddresses[i];
            IBNBWallet wallet = IBNBWallet(walletContractAddress);
            
            uint bnbBalance = wallet.BNBBalanceOf();
            if(bnbBalance>0)
            {
                (uint amount, address destinationAddress) = wallet.sweepBNB();
                emit BNBSweepEvent(amount, destinationAddress, address(this),walletContractAddress,clientId);
            }
        }
        return true;

    }
    
    function sweepBNB(address walletContractAddress)onlyOwner external returns(bool){
        string memory clientId = contractWalletOwners[walletContractAddress];
        require( keccak256( bytes(clientId)) != keccak256(bytes("")),"MerchantWallet: Contract is not a merchant wallet ether wallet contract ");
         IBNBWallet wallet = IBNBWallet(walletContractAddress);
        (uint amount, address destinationAddress) = wallet.sweepBNB();
        emit BNBSweepEvent(amount, destinationAddress, address(this),walletContractAddress,clientId);
    }
    
    
    function sweepTokens(address tokenAddress,  string calldata clientId)onlyOwner external returns (bool){
         
        require(bnbContractWallets[clientId].length > 0, "MerchantWallet: Ether wallet does not exist");
         address[] memory walletContractAddresses = bnbContractWallets[clientId];
         
         address walletMerchantContractAddress = address(this);
         string memory _clientId = clientId;
         
        for(uint i = 0; i < walletContractAddresses.length; ++i ){
           
            address walletContractAddress =  walletContractAddresses[i];
           IBNBWallet wallet = IBNBWallet(walletContractAddress);
            
            uint tokenBalance = wallet.tokenBalanceOf(tokenAddress);
            if(tokenBalance>0)
            {
                (uint amount,address _tokenAddress,address  destinationAddress) = wallet.sweepTokens(tokenAddress);
                emit TokenSweepEvent(amount,_tokenAddress, destinationAddress, walletMerchantContractAddress,walletContractAddress,_clientId);
            }
        }
        return true;

    }
    
    
    function sweepTokens(address walletContractAddress, address tokenAddress)onlyOwner external returns (bool){
        string memory clientId = contractWalletOwners[walletContractAddress];
        require( keccak256( bytes(clientId)) != keccak256(bytes("")),"MerchantWallet: Contract is not a merchant wallet ether wallet contract ");
        
        IBNBWallet wallet = IBNBWallet(walletContractAddress);
        (uint amount,address _tokenAddress, address destinationAddress) = wallet.sweepTokens(tokenAddress);
        emit TokenSweepEvent(amount,_tokenAddress, destinationAddress, address(this),walletContractAddress,clientId);

    }
    
    
     function tokenBalanceOf(address walletContractAddress,address tokenAddress) external view  returns (uint amount){
        IBNBWallet wallet = IBNBWallet(walletContractAddress);
        return wallet.tokenBalanceOf(tokenAddress);
    }
    
    function tokenDecimals(address walletContractAddress,address tokenAddress) external view  returns (uint8 decimals){
        IBNBWallet wallet = IBNBWallet(walletContractAddress);
        return wallet.tokenDecimals(tokenAddress);
    }
    
    function BNBBalanceOf(address walletContractAddress) external view  returns (uint amount){
       IBNBWallet wallet = IBNBWallet(walletContractAddress);
       return wallet.BNBBalanceOf();
    }

    function getClients() public view returns (string[] memory){
        return clients;
    }
    
    function getClientBNBWalletAddress(string calldata clientId, uint index) external view returns(address){
         require(bnbContractWallets[clientId].length > 0, "MerchantWallet: Ether wallet does not exist");
         require(bnbContractWallets[clientId].length > index, "MerchantWallet: User does not have this many wallets");
         address walletContractAddress;
         address[] memory walletContractAddresses = bnbContractWallets[clientId];
           for(uint i = 0; i < walletContractAddresses.length; ++i ){
           
           if(i==index)
              walletContractAddress =   walletContractAddresses[i];

         }
         
         require(walletContractAddress!=address(0),"MerchantWallet: COuld not find wallet at this index");
         return walletContractAddress;
         
    }
    
     function getClientWalletCount(string calldata clientId) external view returns(uint count){
        
         address[] memory walletContractAddresses = bnbContractWallets[clientId];
         return walletContractAddresses.length;  
    }
    
  
}