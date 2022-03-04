// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {
    //array save img kryptobird
    string[] public kryptoBird;
    //mapping check kryptoBird does not exist
    mapping(string => bool) private _kryptoBirdExists;

    constructor() ERC721Connector('Kryptobird', 'KBZ') {

    }

    function mint(string memory items) public {
        //require kryptoBird does not exist
        require(!_kryptoBirdExists[items], 'Kryptobird already exists!');
        kryptoBird.push(items);
        uint256 _id = kryptoBird.length - 1;
        _mint(msg.sender, _id);
        _kryptoBirdExists[items] = true;
    }
}