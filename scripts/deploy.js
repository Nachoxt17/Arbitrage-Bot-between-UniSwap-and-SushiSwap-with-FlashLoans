async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const BaseSmartContract = await ethers.getContractFactory(
    "BaseSmartContract"
  );
  const baseSmartContract = await BaseSmartContract.deploy();

  console.log("BaseSmartContract Contract Address:", baseSmartContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
