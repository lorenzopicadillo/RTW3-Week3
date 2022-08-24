// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// Contract deployed to 0x9f63880Ea3eA2724C3e348c66d14054671A4Ed52

contract ChainBattles is ERC721URIStorage  {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    
    struct TokenStruct {
        uint256 level;
        uint256 hp;
        uint256 strength;
        uint256 speed;
    }

    mapping(uint256 => TokenStruct) public tokenIdToVariables;

    constructor() ERC721 ("Chain Battles", "CBTLS"){
    }

    // function generateRandom(uint number) private view returns (uint) {
    //     return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, number))) % 1000;
    // }

    function createRandom(uint number) view public returns(uint){
        // return (uint(keccak256(abi.encodePacked(_number++))) % 100) / 10;
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, number))) % 1000;
    }

    function generateCharacter(uint256 tokenId) view public returns(string memory){
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Level: ",getLevel(tokenId),'</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Hp: ",getHp(tokenId),'</text>',
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(tokenId),'</text>',
            '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(tokenId),'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            ));
    }

    function getLevel(uint256 tokenId) public view returns (string memory) {
        uint256 level = tokenIdToVariables[tokenId].level;
        return level.toString();
    }
    
    function getHp(uint256 tokenId) public view returns (string memory) {
        uint256 hp = tokenIdToVariables[tokenId].hp;
        return hp.toString();
    }
    
    function getStrength(uint256 tokenId) public view returns (string memory) {
        uint256 strength = tokenIdToVariables[tokenId].strength;
        return strength.toString();
    }
    
    function getSpeed(uint256 tokenId) public view returns (string memory) {
        uint256 speed = tokenIdToVariables[tokenId].speed;
        return speed.toString();
    }

    function getTokenURI(uint256 tokenId) view public returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToVariables[newItemId].level = 0;
        tokenIdToVariables[newItemId].hp = 0;
        tokenIdToVariables[newItemId].strength = 0;
        tokenIdToVariables[newItemId].speed = 0;
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId));
        require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");
        uint256 currentLevel = tokenIdToVariables[tokenId].level;
        tokenIdToVariables[tokenId].level = currentLevel + 1;
        uint256 currentHp = tokenIdToVariables[tokenId].hp;
        tokenIdToVariables[tokenId].hp = currentHp + ((uint(keccak256(abi.encodePacked((block.timestamp-1), msg.sender, currentHp))) % 1000)/100);
        uint256 currentStrength = tokenIdToVariables[tokenId].strength;
        tokenIdToVariables[tokenId].strength =  currentStrength + ((uint(keccak256(abi.encodePacked((block.timestamp-2), msg.sender, currentStrength))) % 1000)/100);
        uint256 currentSpeed = tokenIdToVariables[tokenId].speed;
        tokenIdToVariables[tokenId].speed =  currentSpeed + ((uint(keccak256(abi.encodePacked((block.timestamp-3), msg.sender, currentSpeed))) % 1000)/100);
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
