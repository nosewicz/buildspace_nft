// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  //use counters to keep track of token IDs.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;


  //for svg code. base svg variable all NFTs can use
  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

  //create three arrays, each with own theme of random words
  string[] firstWords = ["Hot", "Sexy", "Incredible", "Attractive", "Pleasing", "Pleasurable"];
  string[] secondWords = ["Female", "Woman", "Male", "Man", "Trans", "Trap"];
  string[] thirdWords = ["Boobs", "Lips", "Dongers", "Butt", "Secretions", "Pussy"];

  event NewEpicNFTMinted(address sender, uint256 tokenId);
  
  //name and symbol of NFTs
  constructor() ERC721 ("Not Appropriate Phrases", "CRINGE") {
    console.log("this is my contract brah");
  }

  //functions to pick a random word from each array
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    //seed generator
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    //keep # between 0 and length of array
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
    rand = rand % secondWords.length;
    return secondWords[rand];
  }

  function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
    rand = rand % thirdWords.length;
    return thirdWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  //function for users to get their NFT
  function makeAnEpicNFT() public {
    //get current tokenId
    uint256 newItemId = _tokenIds.current();
    //require tokenID to be less than 50 (our max mint number)
    require(newItemId < 50);

    //randomly get one word from each array
    string memory first = pickRandomFirstWord(newItemId);
    string memory second = pickRandomSecondWord(newItemId);
    string memory third = pickRandomThirdWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first, second, third));

    //concatenate strings together then close <text> and <svg> tags
    string memory finalSvg = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));
    console.log("\n----------");
    console.log(finalSvg);
    console.log("---------\n");

    //get all metadata in place and base64 encode it
    string memory json = Base64.encode(
      bytes(
        string(
          abi.encodePacked(
            '{"name": "',combinedWord,'", "description": "A very cringey and innapropriate collection of words.", "image": "data:image/svg+xml;base64,',Base64.encode(bytes(finalSvg)),'"}'
          )
        )
      )
    );

    string memory finalTokenUri = string(
      abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(
    string(
      abi.encodePacked(
          "https://nftpreview.0xdev.codes/?code=",
          finalTokenUri
        )
      )
    );
    console.log("--------------------\n");

    //mint the NFT to sender using msg.sender
    _safeMint(msg.sender, newItemId);

    //set NFT's data
    _setTokenURI(newItemId, finalTokenUri);
    console.log("An NFT with ID %s has been minted to %s", newItemId, msg.sender);

    //increment the counter for next token minted
    _tokenIds.increment();

    //emit event
    emit NewEpicNFTMinted(msg.sender, newItemId);
  }

  function getTotalNFTsMintedSoFar() public view returns (uint256) {
    return _tokenIds.current();
  }
}