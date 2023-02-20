# Greenade

Greenade is a decentralized carbon credit platform that allows customers to buy carbon credits from producers using tokens. The platform consists of four smart contracts written in Solidity: 

1. CarbonRegistry - This is the smart contract where various companies can come and provide proof that they generated mWH of electricity and put it on the blockchain.
2. Verifier - This is a smart contract where authorized verifiers can verify that the projects uploaded in the registry are legit and can approve the same using a multi-sig mechanism.
3. Token - This is a normal ERC20 token, which is minted every time a project is verified, proportional to the mwh generated and is burnt when a customer wants to avail the carbon credit NFT.
4. AMM - This is a smart contract used for market making the Token with stable coins or in this case (TFIL aka Testnet FIL).

We are live on Hyperspace Testnet - 

Token - 0xB4652c0BD9Df997a93b1CAa476e94336089F1b99
Carbon Registry - 0xe061B68D9022D7776B9fBE24EE3d6e23e2008474

## Getting Started

### Prerequisites

- Node.js
- Truffle

### Installation

1. Clone the repository.
2. Install the dependencies with `npm install`.
3. Compile the contracts with `truffle compile`.
4. Deploy the contracts with `truffle migrate`.

### Usage

To interact with the smart contracts, you can use the Truffle console or write scripts in JavaScript. Here's an example script that uses the CarbonRegistry contract:

```javascript
const CarbonRegistry = artifacts.require("CarbonRegistry");

module.exports = async function(callback) {
  const registry = await CarbonRegistry.deployed();
  const mwh = 100;
  const sender = web3.eth.accounts[0];
  await registry.addProject(mwh, { from: sender });
  const projects = await registry.getProjects();
  console.log(projects);
  callback();
}
```

This script adds a project to the CarbonRegistry contract with a mwh value of 100, and then retrieves the list of projects.

# Contributing

If you would like to contribute to this project, please fork the repository and submit a pull request.

# License

This project is licensed under the MIT License - see the LICENSE file for details.
