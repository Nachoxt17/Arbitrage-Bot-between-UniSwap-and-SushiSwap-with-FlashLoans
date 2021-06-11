async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const ArbitrageFlashLoaner = await ethers.getContractFactory(
    "ArbitrageFlashLoaner"
  );
  const arbitrageFlashLoaner = await ArbitrageFlashLoaner.deploy();

  console.log("BaseSmartContract Contract Address:", arbitrageFlashLoaner.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
