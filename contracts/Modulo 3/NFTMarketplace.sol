// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract NFTMarketplace is ERC721Holder, ReentrancyGuard, Ownable, Pausable {
    // Struct to store listing information
    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool isActive;
    }

    // Mapping from listing ID to Listing struct
    mapping(uint256 => Listing) public listings;

    // Counter for generating unique listing IDs
    uint256 private _listingIdCounter;

    // Events
    event ListingCreated(uint256 indexed listingId, address indexed seller, address indexed nftContract, uint256 tokenId, uint256 price);
    event ListingCancelled(uint256 indexed listingId);
    event ListingSold(uint256 indexed listingId, address indexed buyer, uint256 price);
    event ListingPriceChanged(uint256 indexed listingId, uint256 newPrice);

    // Constructor
    constructor() Ownable(msg.sender) {
        _listingIdCounter = 0;
    }

    // Function to create a new listing
    function createListing(address _nftContract, uint256 _tokenId, uint256 _price) external whenNotPaused nonReentrant {
        require(_price > 0, "Price must be greater than zero");
        
        IERC721 nftContract = IERC721(_nftContract);
        require(nftContract.ownerOf(_tokenId) == msg.sender, "You don't own this NFT");
        require(nftContract.isApprovedForAll(msg.sender, address(this)), "Contract must be approved to transfer NFT");

        uint256 listingId = _listingIdCounter++;
        listings[listingId] = Listing({
            seller: msg.sender,
            nftContract: _nftContract,
            tokenId: _tokenId,
            price: _price,
            isActive: true
        });

        nftContract.safeTransferFrom(msg.sender, address(this), _tokenId);

        emit ListingCreated(listingId, msg.sender, _nftContract, _tokenId, _price);
    }

    // Function to cancel a listing
    function cancelListing(uint256 _listingId) external whenNotPaused nonReentrant {
        Listing storage listing = listings[_listingId];
        require(listing.isActive, "Listing is not active");
        require(listing.seller == msg.sender, "You're not the seller");

        listing.isActive = false;
        IERC721(listing.nftContract).safeTransferFrom(address(this), msg.sender, listing.tokenId);

        emit ListingCancelled(_listingId);
    }

    // Function to buy a listed NFT
    function buyNFT(uint256 _listingId) external payable whenNotPaused nonReentrant {
        Listing storage listing = listings[_listingId];
        require(listing.isActive, "Listing is not active");
        require(msg.value >= listing.price, "Insufficient payment");

        listing.isActive = false;
        IERC721(listing.nftContract).safeTransferFrom(address(this), msg.sender, listing.tokenId);

        uint256 amount = listing.price;
        payable(listing.seller).transfer(amount);

        if (msg.value > amount) {
            payable(msg.sender).transfer(msg.value - amount);
        }

        emit ListingSold(_listingId, msg.sender, amount);
    }

    // Function to change the price of a listing
    function changeListingPrice(uint256 _listingId, uint256 _newPrice) external whenNotPaused nonReentrant {
        require(_newPrice > 0, "Price must be greater than zero");
        Listing storage listing = listings[_listingId];
        require(listing.isActive, "Listing is not active");
        require(listing.seller == msg.sender, "You're not the seller");

        listing.price = _newPrice;

        emit ListingPriceChanged(_listingId, _newPrice);
    }

    // Function to pause the contract
    function pause() external onlyOwner {
        _pause();
    }

    // Function to unpause the contract
    function unpause() external onlyOwner {
        _unpause();
    }

    // Function to withdraw any stuck ETH (only owner)
    function withdrawStuckETH() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}