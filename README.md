# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
GAS_REPORT=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

npm i @openzeppelin/contracts @nomiclabs/hardhat-etherscan dotenv
npx hardhat run scripts/deploy.js --network mumbai
npx hardhat verify 0x9f63880Ea3eA2724C3e348c66d14054671A4Ed52 --network mumbai

function \_generateRandomStats(uint \_randNonce) private view returns (uint) {
return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, \_randNonce))) % levelStatModulus;
}
And then, to have different value I did
in mint()
uint \_rngLevel = \_generateRandomStats(newItemId);
uint \_rngHp = \_generateRandomStats(\_rngLevel);
uint \_rngStrength = \_generateRandomStats(\_rngHp);
uint \_rngSpeed = \_generateRandomStats(\_rngStrength);
