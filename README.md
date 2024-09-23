## NFT Marketplace ##
This is my final project of Module 3 of the ETH Developer Program running on Costa Rica for the second half of 2024.
<p align="center">
  <img src="https://github.com/user-attachments/assets/a05f5895-c576-49a4-a494-4cd34e4b69ab" alt="NFT Market Image">
</p>

### Contract Description ###

Let's break down the key components and design patterns used:

1. **Imports and Inheritance:**
   - We import necessary OpenZeppelin contracts for ERC721 interface, security, and access control.
   - The contract inherits from ERC721Holder (to receive NFTs), ReentrancyGuard (to prevent reentrancy attacks), Ownable (for access control), and Pausable (to pause/unpause the contract).

2. **Struct and Mapping:**
   - `Listing` struct stores information about each NFT listing.
   - `listings` mapping associates listing IDs with Listing structs.

3. **Events:**
   - Events are defined for important actions like creating, cancelling, and selling listings.

4. **Constructor:**
   - Initializes the contract with the deployer as the owner.

5. **createListing Function:**
   - Allows users to create new listings.
   - Implements checks for valid price, ownership, and approval.
   - Uses the `nonReentrant` modifier to prevent reentrancy attacks.

6. **cancelListing Function:**
   - Allows sellers to cancel their listings.
   - Checks if the caller is the seller and if the listing is active.

7. **buyNFT Function:**
   - Allows users to purchase listed NFTs.
   - Implements checks for listing activity and sufficient payment.
   - Transfers the NFT to the buyer and the payment to the seller.
   - Refunds any excess payment.

8. **changeListingPrice Function:**
   - Allows sellers to change the price of their listings.

9. **Pause and Unpause Functions:**
   - Allows the owner to pause and unpause the contract in case of emergencies.

10. **withdrawStuckETH Function:**
    - Allows the owner to withdraw any ETH stuck in the contract.

11. **Factory Pattern:**
    - While not explicitly implemented as a separate factory contract, the `createListing` function acts as a factory method for creating new listings.

12. **Modifiers:**
    - `whenNotPaused`: Ensures functions can't be called when the contract is paused.
    - `nonReentrant`: Prevents reentrancy attacks.
    - `onlyOwner`: Restricts access to certain functions to the contract owner.

### Summary ###
This contract provides a NFT marketplace with key features like listing creation, cancellation, purchasing, and price adjustment. 
The incorporated design patterns (Ownable, Pausable, Reentrancy Guard) enhance its security and controllability.

#### Closing Recap ####

- Listing Management interacts with Data Storage to create, modify, and remove listings.
- NFT Purchase interacts with Listing Management and Data Storage to process purchases.
- Access Control governs which functions different users can access.
- Security Features are applied across various functions to prevent attacks and allow pausing.
- Events are emitted by different operations to log important actions.
- External Interactions show how the contract communicates with NFT contracts and handles ETH transfers.
