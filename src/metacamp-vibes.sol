// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract MetaCampVibes is ERC721, ERC721URIStorage, ERC721Pausable, AccessControl, ERC721Burnable {
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    uint256 private _nextTokenId;

    constructor() ERC721("MetaCamp Vibes", "MCV") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "example.com";
    }

    function pause() public onlyRole(MANAGER_ROLE) {
        _pause();
    }

    function unpause() public onlyRole(MANAGER_ROLE) {
        _unpause();
    }

    function safeMint(address to, string memory uri) public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function grantManagerRole(address account) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(MANAGER_ROLE, account);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Pausable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
