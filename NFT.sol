// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleERC721 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event TokenURIUpdated(uint256 indexed tokenId, string tokenURI);

    mapping(uint256 => address) private _tokenOwner;
    mapping(address => uint256) private _ownedTokensCount;
    mapping(uint256 => string) private _tokenURIs; // Mapping for token URIs

    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "Address is zero");
        return _ownedTokensCount[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _tokenOwner[tokenId];
        require(owner != address(0), "Token ID does not exist");
        return owner;
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_exists(tokenId), "Token ID does not exist");
        return _tokenURIs[tokenId];
    }

    function setTokenURI(uint256 tokenId, string memory uri) public {
        require(_exists(tokenId), "Token ID does not exist");
        require(ownerOf(tokenId) == msg.sender, "Only owner can set token URI"); // Ensuring the message sender is the owner
        _tokenURIs[tokenId] = uri;
        emit TokenURIUpdated(tokenId, uri);
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: minting to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");
        
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    function mintUniqueTokenTo(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }
}
