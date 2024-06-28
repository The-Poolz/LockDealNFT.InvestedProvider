import { ethers } from "hardhat"

async function main() {
    const lockDealNFT = ""
    const InvestedProvider = await ethers.getContractFactory("InvestedProvider")
    const investedProvider = await InvestedProvider.deploy(lockDealNFT)

    await investedProvider.deployed()

    console.log("InvestedProvider deployed to:", investedProvider.address)
}

main().catch((error) => {
    console.error(error)
    process.exitCode = 1
})
