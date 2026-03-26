// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
// import {ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract NFTMinting is
    ERC721,
    Ownable,
    ReentrancyGuard,
    PaymentSplitter
{
    bytes32 immutable merklaRoot;
    string private baseURL;

    bool public isPasused;
    bool public isPreSaleActive;
    bool public isPublic;
    
    uint tokenId;
    uint public constant PRESALE_LIMIT = 5;
    uint public constant NFT_PRICE = 0.001 ether;
    uint public constant MAX_SUPPLY = 20;

    address[] public temMembers = [
        0x5B38Da6a701c568545dCfcB03FcB875f56beddC4,
        0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2,
        0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db
    ];
    uint256[] public teamShars = [20, 30, 50];

  //mappings..........................................................
    mapping (address => uint) preSaleCount;
    mapping (address => uint) publicSaleCount;
    //mapping to whic token holf which CID
    // mapping (uint => string) tokenUrl;
      // Optional mapping for token URIs
     mapping(uint256  => string) public  _tokenURIs;



    

    //events ......................................................
    /// @dev This event emits when the metadata of a token is changed.
    /// So that the third-party platforms such as NFT market could
    /// timely update the images and related attributes of the NFT.
    event MetadataUpdate(uint256 _tokenId);
    


 
 //modifires...................................
    //check only call user this function not other contracts
    modifier onlyEOA() {
        require(
            tx.origin == msg.sender,
            "Only Access For User Not Contracts NO Call this function ."
        );
        _;
    }

    //to check proof is valid or not
    modifier isVerified(bytes32[] calldata _proof) {
        require(
            MerkleProof.verify(
                _proof,
                merklaRoot,
                keccak256(abi.encodePacked((msg.sender)))
            ),
            "Proof Not valid!"
        );
        _;
    }

    //construtor
    constructor(
        string memory initialBaseURL,
        bytes32 root
    )
        ERC721("NEW NFT", "NFT")
        Ownable(msg.sender)
        ReentrancyGuard()
        PaymentSplitter(temMembers, teamShars)
    {
        baseURL = initialBaseURL;
        merklaRoot = root;
    }



    //toggal
    function togglePreSale( ) external  onlyOwner {
        isPreSaleActive = !isPreSaleActive;
    }

      //toggal
    function togglePublicSale( ) external onlyOwner  {
            isPublic = !isPublic;
    }
    


    // NFTs minting function 
    function _minNFT(address _to , string memory _CID) internal {
            _safeMint(_to , tokenId);
        //mapping with token and cids
        // tokenUrl[tokenId] = _CID;
        _setTokenURI(tokenId , _CID);
        tokenId++;
    }
 
  //  function to set tokeUrl with tokenId     
    function _setTokenURI(uint256 _tokenId, string memory _tokenURI) internal  {
    _tokenURIs[_tokenId] = _tokenURI;
    emit MetadataUpdate(tokenId);
    }




  // only people that belong fron list or group that peoples ontl mint ther nfts
    function preSale(uint nftAmount , bytes32[] calldata proof , string[] calldata cids  ) external  onlyEOA nonReentrant isVerified(proof) {
     //check multiple conditions
     require(isPublic==true, "Contract is Not Publicly Active!");
     require(isPreSaleActive , "PreSale Is Not Active!");
     require(nftAmount > 0 ,"NFt Amount is not Zero!");
     //check user nft limits
     require(preSaleCount[msg.sender] + nftAmount <= PRESALE_LIMIT , " PRESALE_LIMIT eceed!");
     require(tokenId + nftAmount <= MAX_SUPPLY , "MAX_SUPPLY Of NFt TOken is eceed!, we can not create new nft");
     //check not ot nfts is requal to CID => this is come fro IPFS
     //cID => content identifier to use for get or nft in stored on ipfs also this is indetife of out nft or image
     require(cids.length == nftAmount , "CDS is Not equls to NFT AMOUNTS !");


     //now create nfts based upon user count
     preSaleCount[msg.sender] += nftAmount;

     //loop on nft counts so we mint nft one by one for user  CDNS
     for (uint i=0; i < nftAmount ; i++) 
     {
        //mint one by one
        // address and tokenId
        _minNFT(msg.sender, cids[i]);
     }

    


    }
   

   //public mint -- anyone can mint nft 
    function publicSale(uint nftAmount , string[] calldata cids  ) external  onlyEOA nonReentrant {
     //check multiple conditions
     require(isPublic==true, "Contract is Not Publicly Active!");
     require(isPreSaleActive , "PreSale Is Not Active!");
     require(nftAmount > 0 ,"NFt Amount is not Zero!");
     require(cids.length == nftAmount , "CDS is Not equls to NFT AMOUNTS !");
      
      

     //loop on nft counts so we mint nft one by one for user  CDNS
     for (uint i=0; i < nftAmount ; i++) 
     {
        //mint one by one
        // address and tokenId
        _minNFT(msg.sender, cids[i]);
     }
      publicSaleCount[msg.sender] += nftAmount;

    }



       // Use 'view' for read-only functions
    function myNftTokenUrl(uint256 _tokenId) public view returns (string memory) {
        // Use abi.encodePacked to concatenate strings in Solidity
        return string(abi.encodePacked(baseURL, _tokenURIs[_tokenId]));
    }



           


     



}






// 0xeeefd63003e0e702cb41cd0043015a6e26ddb38073cc6ffeb0ba3e808ba8c097

//proof:
// ["0x5931b4ed56ace4c46b68524cb5bcbf4195f1bbaacbe5228fbd090546c88dd229","0x4726e4102af77216b09ccd94f40daa10531c87c4d60bba7f3b3faf5ff9f19b3c"]




//cids :
//  ["bafkreia4wsbco23tsj7zuoaley5rvt4xolbfsewjn4j6wflnx4xqdngoju","bafkreia7mnlckmmrjdxwv653ncldblgbxyxysknui3ibwb5heibkwlelze"]