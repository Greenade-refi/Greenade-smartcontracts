pragma solidity ^0.8.0;

// Import SafeMath library to avoid integer overflow/underflow vulnerabilities
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// Define a custom error message
error VerifierNotAuthorized();

// Define the verifier contract
contract Verifier {
    using SafeMath for uint256;

    // The minimum number of verifiers required to approve a project
    uint256 public approvalThreshold;

    // A mapping of authorized verifiers
    mapping(address => bool) public authorizedVerifiers;

    // A mapping of projects to the number of approvals they have received
    mapping(address => uint256) public approvals;

    // A function to add an authorized verifier
    function addAuthorizedVerifier(address verifier) public {
        // Safety check
        require(msg.sender == owner, "Only the owner can add an authorized verifier");
        require(verifier != address(0), "Invalid verifier address");
        authorizedVerifiers[verifier] = true;
    }

    // A function to remove an authorized verifier
    function removeAuthorizedVerifier(address verifier) public {
        require(msg.sender == owner, "Only the owner can remove an authorized verifier");
        require(verifier != address(0), "Invalid verifier address");
        authorizedVerifiers[verifier] = false;
    }

    // A function to approve a project
    function approveProject(address projectAddress) public {
        require(authorizedVerifiers[msg.sender], "Verifier is not authorized");
        require(!hasApprovedProject(projectAddress), "Project has already been approved");
        approvals[projectAddress] = approvals[projectAddress].add(1);
    }

    // A function to check whether a project has received enough approvals to be considered verified
    function isProjectVerified(address projectAddress) public view returns (bool) {
        return approvals[projectAddress] >= approvalThreshold;
    }

    // A function to check whether a verifier has approved a project
    function hasApprovedProject(address projectAddress) public view returns (bool) {
        return approvals[projectAddress] > 0 && authorizedVerifiers[msg.sender];
    }

    // Modifier to restrict access to the contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    // The contract owner
    address public owner;

    // The constructor function
    constructor(uint256 _approvalThreshold) {
        require(_approvalThreshold > 0, "Approval threshold must be greater than zero");
        approvalThreshold = _approvalThreshold;
        owner = msg.sender;
    }
}

