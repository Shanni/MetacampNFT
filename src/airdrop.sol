// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MetaCampPass is ERC721Enumerable, Ownable, ReentrancyGuard {
    mapping(address => bool) public whitelist;
    bool public saleActive = false;

    address primarySaleRecipient;
    constructor(
        address _defaultAdmin,
        string memory _name,
        string memory _symbol
    )
        ERC721Enumerable()
        ERC721(_name, _symbol)
    {
        transferOwnership(_defaultAdmin);
        // Set royalty and primary sale recipient if needed
        primarySaleRecipient = _defaultAdmin;
    }

    function setPrimarySaleRecipient(address _primarySaleRecipient) external onlyOwner {
        primarySaleRecipient = _primarySaleRecipient;
    }
    
    function setLoyaltyRecipient(address _loyaltyRecipient, uint128 _loyaltyBps) external onlyOwner {
        _setRoyaltyRecipient(_loyaltyRecipient, _loyaltyBps);
    }

    function setLoyaltyRecipient(address _loyaltyRecipient, uint128 _loyaltyBps) external onlyOwner {
        _setRoyaltyRecipient(_loyaltyRecipient, _loyaltyBps);
    }

    function addToWhitelist(address[] calldata _addresses) external onlyOwner {
        for (uint256 i = 0; i < _addresses.length; i++) {
            whitelist[_addresses[i]] = true;
        }
    }

    function removeFromWhitelist(address[] calldata _addresses) external onlyOwner {
        for (uint256 i = 0; i < _addresses.length; i++) {
            whitelist[_addresses[i]] = false;
        }
    }

    function setSaleActive(bool _active) external onlyOwner {
        saleActive = _active;
    }

    function claim() external nonReentrant {
        require(saleActive, "Sale is not active");
        require(whitelist[msg.sender], "You are not whitelisted");
        require(balanceOf(msg.sender) == 0, "You have already claimed");

        uint256 tokenId = totalSupply() + 1;
        _safeMint(msg.sender, tokenId);
    }

    // Override _baseURI to return the base URI for your metadata
    function _baseURI() internal view virtual override returns (string memory) {
        return "https://your-metadata-url/";
    }

    // Override _beforeTokenTransfer to enforce additional rules if necessary
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // Override supportsInterface to include the interfaces this contract implements
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
