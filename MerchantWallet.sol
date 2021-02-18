pragma solidity ^0.6.4;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";
//import "./IERC20Wallet.sol";
//import "./ERC20Wallet.sol";

import "./IEtherWallet.sol";
import "./EtherWallet.sol";

import "./IERC20.sol";

contract MerchantWallet is Ownable {

    string[] public clients;

   
    //A map of a user's ether wallets
    mapping(string => address[]) public etherContractWallets;
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
    
    event EtherSweepEvent ( 
        uint256 amount,
        address destinationAddress,
        address merchantWalletAddress,
        address contractWalletAddress,
        string clientId

    );
    

    constructor(address _walletAdmin,address payable _owner) public {
        owner = _owner;
        walletAdmin = _walletAdmin;
    }

    function createEtherWallet(string calldata clientId) onlyOwner external returns (bool) {
        require(etherContractWallets[clientId].length == 0, "MerchantWallet: Ether wallet exists");
        createWallet(clientId);
        clients.push(clientId);
        return true;
    }

    function addNewEtherWallet(string calldata clientId) onlyOwner external returns (bool) {
        createWallet(clientId);
        return true;
    }
    
    
    function createWallet(string memory clientId) internal {
        EtherWallet etherWallet = new EtherWallet(owner,walletAdmin);
        etherContractWallets[clientId].push(address(etherWallet));
        contractWalletOwners[address(etherWallet)] = clientId;
        emit WalletCreationEvent(address(etherWallet),address(this), clientId);
    }
    
    
     function sweepEthers(string calldata clientId)onlyOwner external returns (bool){
         
        require(etherContractWallets[clientId].length > 0, "MerchantWallet: Ether wallet does not exist");
         address[] memory walletContractAddresses = etherContractWallets[clientId];
        for(uint i = 0; i < walletContractAddresses.length; ++i ){
           
            address walletContractAddress =  walletContractAddresses[i];
            IEtherWallet wallet = IEtherWallet(walletContractAddress);
            
            uint etherBalance = wallet.etherBalanceOf();
            if(etherBalance>0)
            {
                (uint amount, address destinationAddress) = wallet.sweepEthers();
                emit EtherSweepEvent(amount, destinationAddress, address(this),walletContractAddress,clientId);
            }
        }
        return true;

    }
    
    function sweepEthers(address walletContractAddress)onlyOwner external returns(bool){
        string memory clientId = contractWalletOwners[walletContractAddress];
        require( keccak256( bytes(clientId)) != keccak256(bytes("")),"MerchantWallet: Contract is not a merchant wallet ether wallet contract ");
        IEtherWallet wallet = IEtherWallet(walletContractAddress);
        (uint amount, address destinationAddress) = wallet.sweepEthers();
        emit EtherSweepEvent(amount, destinationAddress, address(this),walletContractAddress,clientId);
    }
    
    
    function sweepTokens(address tokenAddress,  string calldata clientId)onlyOwner external returns (bool){
         
        require(etherContractWallets[clientId].length > 0, "MerchantWallet: Ether wallet does not exist");
         address[] memory walletContractAddresses = etherContractWallets[clientId];
         
         address walletMerchantContractAddress = address(this);
         string memory _clientId = clientId;
         
        for(uint i = 0; i < walletContractAddresses.length; ++i ){
           
            address walletContractAddress =  walletContractAddresses[i];
            IEtherWallet wallet = IEtherWallet(walletContractAddress);
            
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
        
        IEtherWallet wallet = IEtherWallet(walletContractAddress);
        (uint amount,address _tokenAddress, address destinationAddress) = wallet.sweepTokens(tokenAddress);
        emit TokenSweepEvent(amount,_tokenAddress, destinationAddress, address(this),walletContractAddress,clientId);

    }
    
    
     function tokenBalanceOf(address walletContractAddress,address tokenAddress) external view  returns (uint amount){
        IEtherWallet wallet = IEtherWallet(walletContractAddress);
        return wallet.tokenBalanceOf(tokenAddress);
    }
    
    function tokenDecimals(address walletContractAddress,address tokenAddress) external view  returns (uint8 decimals){
        IEtherWallet wallet = IEtherWallet(walletContractAddress);
        return wallet.tokenDecimals(tokenAddress);
    }
    
    function etherBalanceOf(address walletContractAddress) external view  returns (uint amount){
       IEtherWallet wallet = IEtherWallet(walletContractAddress);
       return wallet.etherBalanceOf();
    }

    function getClients() public view returns (string[] memory){
        return clients;
    }
    
    function getClientEtherWalletAddress(string calldata clientId, uint index) external view returns(address){
         require(etherContractWallets[clientId].length > 0, "MerchantWallet: Ether wallet does not exist");
         require(etherContractWallets[clientId].length > index, "MerchantWallet: User does not have this many wallets");
         address walletContractAddress;
         address[] memory walletContractAddresses = etherContractWallets[clientId];
           for(uint i = 0; i < walletContractAddresses.length; ++i ){
           
           if(i==index)
              walletContractAddress =   walletContractAddresses[i];

         }
         
         require(walletContractAddress!=address(0),"MerchantWallet: COuld not find wallet at this index");
         return walletContractAddress;
         
    }
    
     function getClientWalletCount(string calldata clientId) external view returns(uint count){
        
         address[] memory walletContractAddresses = etherContractWallets[clientId];
         return walletContractAddresses.length;  
    }
    
  
}