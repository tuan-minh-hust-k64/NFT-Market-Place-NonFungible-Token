// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/* 
this contract include function: mint, balanceOf, ...
*/
import './ERC165.sol';
import './interfaces/IERC721.sol';

contract ERC721 is IERC721, ERC165  {
    //mapping from token id to owner
    mapping(uint256 => address) private _tokenOwner;
    //mapping from owner to number of owned tokens
    mapping(address => uint256) private _ownedTokensCount;
    //mapping from token id to approval address
    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(bytes4(
            keccak256('balanceOf(bytes4)')
            ^keccak256('ownerOf(bytes4)')
            ^keccak256('transferFrom(bytes4)')
        ));
    }

    //function check tokenId does not exist
    function _exists(uint tokenId) internal view returns(bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        //require address 'to' exists
        require(to != address(0), 'ERC721: address to invalid!');
        //require tokenID does not exist
        require(!_exists(tokenId), 'ERC721: tokenId already exists!');
        _tokenOwner[tokenId] = to;
        _ownedTokensCount[to] += 1;
        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) public view override returns (uint256) {
        require(_owner != address(0), 'ERC721: Address invalid!');
        return _ownedTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view override returns (address){
        address owner = _tokenOwner[_tokenId];
        require(owner!= address(0), 'ERC721: Address invalid!');
        return owner;
    }

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal{
        require(_to != address(0), "ERC721: Address receive is not a valid!");
        require(_tokenOwner[_tokenId] == _from, "ERC721: Address send is not a valid!");
        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public override {
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 _tokenId) public override {
        address owner = ownerOf(_tokenId);
        require(_to != owner, "ERC721: Not transfer to Address current");
        require(owner == msg.sender, "ERC721: Current caller is not owner of this token");
        _tokenApprovals[_tokenId] = _to;
        emit Approval(owner, _to, _tokenId);
    }
}