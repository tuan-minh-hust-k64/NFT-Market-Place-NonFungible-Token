// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable, ERC721  {

    uint256[] private _allTokens;
    //mapping from tokenId to position in array _allTokens
    mapping(uint256 => uint256) private _allTokensIndex;
    //mapping from owner to list of tokens owner
    mapping(address => uint256[]) private _ownedTokens;
    //mapping from token ID to index in list tokens owner
    mapping(uint256 => uint256) private _ownedTokensIndex;

    constructor(){
        _registerInterface(bytes4(
            keccak256('totalSupply(bytes4)')
            ^keccak256('tokenByIndex(bytes4)')
            ^keccak256('tokenOfOwnerByIndex(bytes4)')
        ));
    }

    function totalSupply() public view override returns (uint256) {
        return _allTokens.length;
    }

    /// @notice Enumerate valid NFTs
    /// @dev Throws if `_index` >= `totalSupply()`.
    /// @param _index A counter less than `totalSupply()`
    /// @return The token identifier for the `_index`th NFT,
    ///  (sort order not specified)
    function tokenByIndex(uint256 _index) external override view returns (uint256) {
        require(_index < totalSupply(), "ERC721: Index out of range!");
        return _allTokens[_index];
    }

    /// @notice Enumerate NFTs assigned to an owner
    /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
    ///  `_owner` is the zero address, representing invalid NFTs.
    /// @param _owner An address where we are interested in NFTs owned by them
    /// @param _index A counter less than `balanceOf(_owner)`
    /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
    ///   (sort order not specified)
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external override view returns (uint256) {
        require(_index < _ownedTokens[_owner].length, "ERC721: Index out of range!");
        return _ownedTokens[_owner][_index];
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);
        _addTokenToAllTokensEnumerable(tokenId);
    }

    function _addTokenToAllTokensEnumerable(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokenToOwnedTokensEnumerable(address to, uint256 tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }
}