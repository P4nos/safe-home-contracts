const InsurancePool = artifacts.require("InsurancePool");

module.exports = async function (deployer, network, accounts) {
  // Deploy InsurancePool
  await deployer.deploy(InsurancePool);
  const insurancePool = await InsurancePool.deployed();
};
