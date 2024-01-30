// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleERC1155 {
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
    event URI(string value, uint256 indexed id);

    mapping(uint256 => mapping(address => uint256)) private _balances;
    mapping(uint256 => string) private _tokenURIs;

    function balanceOf(address account, uint256 id) public view returns (uint256) {
        require(account != address(0), "Address cannot be the zero address");
        return _balances[id][account];
    }

    function setURI(uint256 tokenId, string memory newuri) public {
        _tokenURIs[tokenId] = newuri;
        emit URI(newuri, tokenId);
    }

    function uri(uint256 tokenId) public view returns (string memory) {
        return _tokenURIs[tokenId];
    }

    function mint(address account, uint256 id, uint256 amount, string memory uri_) public {
        require(account != address(0), "Mint to the zero address");
        _balances[id][account] += amount;
        setURI(id, uri_);
        emit TransferSingle(msg.sender, address(0), account, id, amount);
    }

    function transfer(address from, address to, uint256 id, uint256 amount) public {
        require(from == msg.sender, "ERC1155: caller is not owner nor approved");
        require(to != address(0), "ERC1155: transfer to the zero address");

        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
        _balances[id][from] = fromBalance - amount;
        _balances[id][to] += amount;

        emit TransferSingle(msg.sender, from, to, id, amount);
    }
}
