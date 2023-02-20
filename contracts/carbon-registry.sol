pragma solidity ^0.8.0;

// Import the ERC20 interface and the SafeMath library
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// Import the Verifier contract
import "./Verifier.sol";

// Define the CarbonRegistry contract
contract CarbonRegistry {
    using SafeMath for uint256;

    // The address of the Token contract
    address public tokenAddress;

    // The address of the Verifier contract
    address public verifierAddress;

    // A struct to represent a project
    struct Project {
        address owner;
        uint256 mwh;
        bool verified;
    }

    // An array of projects
    Project[] public projects;

    // A mapping of project owners to their project indices
    mapping(address => uint256) public ownerToIndex;

    // An event to indicate that a new project has been added to the registry
    event ProjectAdded(address indexed owner, uint256 indexed mwh, uint256 projectIndex);

    // An event to indicate that a project has been verified
    event ProjectVerified(uint256 indexed projectIndex);

    // An event to indicate that a customer has redeemed a carbon credit
    event CarbonCreditRedeemed(address indexed customer, uint256 indexed mwh);

    // Modifier to restrict access to the Verifier contract
    modifier onlyVerifier() {
        require(msg.sender == verifierAddress, "Only the Verifier contract can call this function");
        _;
    }

    // The constructor function
    constructor(address _tokenAddress, address _verifierAddress) {
        require(_tokenAddress != address(0), "Invalid Token contract address");
        require(_verifierAddress != address(0), "Invalid Verifier contract address");
        tokenAddress = _tokenAddress;
        verifierAddress = _verifierAddress;
    }

    // A function to add a new project to the registry
    function addProject(uint256 mwh) public {
        require(mwh > 0, "Invalid mwh value");
        require(IERC20(tokenAddress).balanceOf(msg.sender) >= mwh, "Insufficient token balance");
        require(IERC20(tokenAddress).allowance(msg.sender, address(this)) >= mwh, "Insufficient token allowance");
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), mwh);
        uint256 index = projects.length;
        projects.push(Project({
            owner: msg.sender,
            mwh: mwh,
            verified: false
        }));
        ownerToIndex[msg.sender] = index;
        emit ProjectAdded(msg.sender, mwh, index);
    }

    // A function to verify a project
    function verifyProject(uint256 projectIndex) public onlyVerifier {
        require(projectIndex < projects.length, "Invalid project index");
        require(!projects[projectIndex].verified, "Project has already been verified");
        Verifier verifier = Verifier(verifierAddress);
        verifier.approveProject(address(this));
        if (verifier.isProjectVerified(address(this))) {
            projects[projectIndex].verified = true;
            emit ProjectVerified(projectIndex);
            // Mint tokens proportional to the mwh generated
            uint256 mwh = projects[projectIndex].mwh;
            uint256 tokenAmount = mwh.mul(10**18); // 1 token per mwh
            IERC20(tokenAddress).mint(projects[projectIndex].owner, tokenAmount);
        }
    }

}

