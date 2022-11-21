const { ethers, deployments, getNamedAccounts } = require('hardhat');

module.exports = async () => {
	const { deploy, log } = deployments;
	const { deployer } = await getNamedAccounts();
	const value = await ethers.utils.parseEther("0.02");

	console.log("Deploying Flash loan...")
	const FLASH = await deploy("FlashLoan", {
		from: deployer,
		log: true,
		contract: "FlashLoan",
		args: [network.config.aave],
		gasLimit: value
	})

}