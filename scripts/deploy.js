async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const ArbitrageFlashLoaner = await ethers.getContractFactory(
    "ArbitrageFlashLoaner"
  );
  const arbitrageFlashLoaner = await ArbitrageFlashLoaner
  .deploy('0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f', '0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac');

  console.log(
    "ArbitrageFlashLoaner Contract Address:",
    arbitrageFlashLoaner.address
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
