pragma solidity ^0.6.0;

/**
 * @dev Interface of the bep20wallet
 */
interface IBEP20Wallet {
    /**
     * @dev Transfers all tokens to contract owner;
     */
    function sweepTokens() external returns(uint,address,address);

    /**
     * @dev Transfers all bnb to contract owner;
     */
    function sweepBNB() external returns(uint,address);
    
     /**
     * @dev Returns the token balance for this contract
     */
    function tokenBalanceOf()  external view returns (uint);
    
     /**
     * @dev Returns the bnb balance for this contract
     */
    function BNBBalanceOf()  external view returns (uint);
    
    function tokenDecimals() external view  returns (uint8);

    
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