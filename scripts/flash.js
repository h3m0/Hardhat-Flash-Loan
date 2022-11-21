const { getNamedAccounts, ethers } = require('hardhat')


async function flash() {
	get
}

async function getWeth(address, amount){
	const value = await ethers.utils.parseEther("0.02");	
	const WETH = await ethers.getContract("WETH");
	const { deployer } = await getNamedAccounts();
	console.log("Depositing...")
	const tx = await WETH.deposit({
		from: address,
		value: amount,
		log: true
	})
	await tx.wait(1);
	console.log("Deposited!")
	const response = await WETH.showBalance(deployer);
	console.log(`${address} has ${amount} WETH!`)
}