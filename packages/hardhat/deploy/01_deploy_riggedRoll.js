const { ethers } = require("hardhat");

const localChainId = "31337";

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  const diceGame = await ethers.getContract("DiceGame", deployer);

  await deploy("RiggedRoll", {
    from: deployer,
    args: [diceGame.address],
    log: true,
  });

  const riggedRoll = await ethers.getContract("RiggedRoll", deployer);

  const ownershipTransaction = await riggedRoll.transferOwnership(
    "0x55b9CB0bCf56057010b9c471e7D42d60e1111EEa"
  );

  await ownershipTransaction.wait(1);
};

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

module.exports.tags = ["RiggedRoll"];
