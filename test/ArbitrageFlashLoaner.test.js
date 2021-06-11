/* eslint-disable no-undef */
const ArbitrageFlashLoaner = artifacts.require("ArbitrageFlashLoaner");

require("chai").use(require("chai-as-promised")).should();

function tokens(n) {
  return web3.utils.toWei(n, "ether");
}

contract("ArbitrageFlashLoaner", ([deployer, investor]) => {
  let arbitrageFlashLoaner;

  before(async () => {
    // Test Something.
  });

  describe("ArbitrageFlashLoaner deployment", async () => {
    it("contract has a name", async () => {
      const name = await arbitrageFlashLoaner.name();
      assert.equal(name, "SampleSmartContract");
    });
  });
});
