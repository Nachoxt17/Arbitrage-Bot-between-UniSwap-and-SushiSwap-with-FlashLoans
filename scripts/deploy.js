async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const EthSwap = await ethers.getContractFactory("EthSwap");
  const ethSwap = await EthSwap.deploy();

  console.log("EthSwap Smart Contract Address:", ethSwap.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
