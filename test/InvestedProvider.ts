import { MockInvestProvider, InvestedProvider } from "../typechain-types"
import { expect } from "chai"
import { ethers } from "hardhat"
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers"
import { LockDealNFT } from "../typechain-types/@poolzfinance/lockdeal-nft/contracts/LockDealNFT/LockDealNFT"
import { ERC20Token } from "../typechain-types/contracts/mock/ERC20Token"
import { BaseContract } from "ethers"

describe("InvestedProvider tests", function () {
    let accounts: SignerWithAddress[]
    let investedProvider: InvestedProvider
    let mockInvestProvider: MockInvestProvider
    let token: ERC20Token
    let lockDealNFT: LockDealNFT
    let poolId: bigint
    let sourcePoolId: bigint
    let params: bigint[]
    const creationSignature: Uint8Array = ethers.toUtf8Bytes("signature")

    before(async () => {
        accounts = await ethers.getSigners()
        const Token = await ethers.getContractFactory("ERC20Token")
        token = (await Token.deploy("TEST", "test")) as ERC20Token
        const VaultManager = await ethers.getContractFactory("MockVaultManager")
        const vaultManager = await VaultManager.deploy()
        const LockDealNFT = await ethers.getContractFactory("LockDealNFT")
        lockDealNFT = (await LockDealNFT.deploy(await vaultManager.getAddress(), "")) as BaseContract as LockDealNFT
        const InvestedProvider = await ethers.getContractFactory("InvestedProvider")
        investedProvider = (await InvestedProvider.deploy(
            await lockDealNFT.getAddress()
        )) as BaseContract as InvestedProvider
        const MockInvestProvider = await ethers.getContractFactory("MockInvestProvider")
        mockInvestProvider = (await MockInvestProvider.deploy(
            await lockDealNFT.getAddress()
        )) as any as MockInvestProvider
        // approve contracts
        await lockDealNFT.setApprovedContract(await mockInvestProvider.getAddress(), true)
        await lockDealNFT.setApprovedContract(await investedProvider.getAddress(), true)
        sourcePoolId = await lockDealNFT.totalSupply()
        params = []
        await token.approve(await vaultManager.getAddress(), ethers.parseEther("1"))
        const addresses = [await accounts[0].getAddress(), await token.getAddress()]
        await mockInvestProvider.createNewPool(addresses, [ethers.parseEther("1")], creationSignature)
    })

    beforeEach(async () => {
        poolId = await lockDealNFT.totalSupply()
    })

    it("should return InvestedProvider name", async () => {
        expect(await investedProvider.name()).to.equal("InvestedProvider")
    })

    it("should create NFT for msg.sender", async () => {
        await mockInvestProvider
            .connect(accounts[1])
            .createInvestedPool(await investedProvider.getAddress(), sourcePoolId)
        expect(await lockDealNFT.ownerOf(poolId)).to.equal(await accounts[1].getAddress())
    })

    it("should save token address", async () => {
        await mockInvestProvider.createInvestedPool(await investedProvider.getAddress(), sourcePoolId)
        expect(await lockDealNFT.tokenOf(poolId)).to.equal(await token.getAddress())
    })

    it("should return 0 when call getWithdrawableAmount", async () => {
        await mockInvestProvider.createInvestedPool(await investedProvider.getAddress(), sourcePoolId)
        expect(await investedProvider.getWithdrawableAmount(poolId)).to.equal(0)
    })

    it("should revert withdraw call", async () => {
        await expect(investedProvider.withdraw(100n)).to.be.revertedWith(
            "withdraw is not allowed for invested provider"
        )
    })

    it("should revert split call", async () => {
        await expect(investedProvider.split(poolId, sourcePoolId, 100n)).to.be.revertedWith(
            "split is not allowed for invested provider"
        )
    })

    it("should return amount from getParams", async () => {
        await mockInvestProvider.createInvestedPool(await investedProvider.getAddress(), sourcePoolId)
        expect((await investedProvider.getParams(poolId)).toString()).to.equal([].toString())
    })

    it("should revert register call", async () => {
        await expect(
            mockInvestProvider.callRegister(await investedProvider.getAddress(), [], sourcePoolId)
        ).to.be.revertedWith("no data to register")
    })

    it("should revert zero address lockDealNFT", async () => {
        const InvestedProvider = await ethers.getContractFactory("InvestedProvider")
        await expect(InvestedProvider.deploy(ethers.ZeroAddress)).to.be.revertedWithCustomError(
            investedProvider,
            "ZeroAddress"
        )
    })

    it("currentParamsTargetLength should return 0", async () => {
        expect(await investedProvider.currentParamsTargetLength()).to.equal(0)
    })
})
