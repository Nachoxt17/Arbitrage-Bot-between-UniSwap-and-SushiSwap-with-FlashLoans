/* eslint-disable no-undef */
const BaseSmartContract = artifacts.require("BaseSmartContract");

require("chai").use(require("chai-as-promised")).should();

function tokens(n) {
  return web3.utils.toWei(n, "ether");
}

contract("BaseSmartContract", ([deployer, investor]) => {
  let baseSmartContract;

  before(async () => {
    // Test Something.
  });

  describe("BaseSmartContract deployment", async () => {
    it("contract has a name", async () => {
      const name = await baseSmartContract.name();
      assert.equal(name, "SampleSmartContract");
    });
  });
});
