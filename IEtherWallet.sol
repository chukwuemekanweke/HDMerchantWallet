pragma solidity ^0.6.0;

/**
 * @dev Interface of the EtherWallet
 */
interface IEtherWallet {
  
    /**
     * @dev Transfers all ethers to contract owner;
     */
    function sweepEthers() external returns(uint,address);


     /**
     * @dev Returns the ether balance for this contract
     */
    function etherBalanceOf() external view returns (uint);
    
    
     /**
     * @dev transfers all tokens to contract owner
     */
    function sweepTokens(address tokenAddress) external returns (uint,address,address);
    
    
     /**
     * @dev Returns token balnce for this contract
     */
    function tokenBalanceOf(address tokenAddress) external view  returns (uint);
    
    
    /**
     * @dev Returns decimal value for token contract
     */

    function tokenDecimals(address tokenAddress) external view  returns (uint8 );
    
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    //event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    //event Approval(address indexed owner, address indexed spender, uint256 value);
}