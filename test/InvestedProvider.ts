import { MockInvestProvider, InvestedProvider, MockVaultManager } from "../typechain-types"
import { expect } from "chai"
import { ethers } from "hardhat"
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers"
import { LockDealNFT } from "../typechain-types/@poolzfinance/lockdeal-nft/contracts/LockDealNFT/LockDealNFT"
import { ERC20Token } from "../typechain-types/contracts/mock/ERC20Token"

describe("InvestedProvider tests", function () {
    let accounts: SignerWithAddress[]
    let investedProvider: InvestedProvider
    let mockInvestProvider: MockInvestProvider
    let token: ERC20Token
    let lockDealNFT: LockDealNFT
    const amount = ethers.parseEther("100")
    let poolId: bigint
    let sourcePoolId: bigint
    let params: bigint[]
    const creationSignature: Uint8Array = ethers.toUtf8Bytes("signature")
    const investPoolId = 58n

    before(async () => {
        accounts = await ethers.getSigners()
        const Token = await ethers.getContractFactory("ERC20Token")
        token = (await Token.deploy("TEST", "test")) as ERC20Token
        const VaultManager = await ethers.getContractFactory("MockVaultManager")
        const vaultManager = (await VaultManager.deploy()) as any as MockVaultManager
        const LockDealNFT = await ethers.getContractFactory("LockDealNFT")
        lockDealNFT = (await LockDealNFT.deploy(await vaultManager.getAddress(), "")) as any as LockDealNFT
        const InvestedProvider = await ethers.getContractFactory("InvestedProvider")
        investedProvider = (await InvestedProvider.deploy(await lockDealNFT.getAddress())) as any as InvestedProvider
        const MockInvestProvider = await ethers.getContractFactory("MockInvestProvider")
        mockInvestProvider = (await MockInvestProvider.deploy(
            await lockDealNFT.getAddress()
        )) as any as MockInvestProvider
        // approve contracts
        await lockDealNFT.setApprovedContract(await mockInvestProvider.getAddress(), true)
        await lockDealNFT.setApprovedContract(await investedProvider.getAddress(), true)
        // create source pool
        await token.approve(await vaultManager.getAddress(), amount)
        sourcePoolId = await lockDealNFT.totalSupply()
        params = [amount, investPoolId]
        const addresses = [await accounts[0].getAddress(), await token.getAddress()]
        await mockInvestProvider.createNewPool(addresses, params, creationSignature)
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
            .createInvestedPool(await investedProvider.getAddress(), params, sourcePoolId)
        expect(await lockDealNFT.ownerOf(poolId)).to.equal(await accounts[1].getAddress())
    })

    it("should save token address", async () => {
        await mockInvestProvider.createInvestedPool(await investedProvider.getAddress(), params, sourcePoolId)
        expect(await lockDealNFT.tokenOf(poolId)).to.equal(await token.getAddress())
    })

    it("should save amount after invest", async () => {
        await mockInvestProvider.createInvestedPool(await investedProvider.getAddress(), params, sourcePoolId)
        expect(await investedProvider.poolIdToAmount(poolId)).to.equal(amount)
    })

    it("should save invest pool id after invest", async () => {
        await mockInvestProvider.createInvestedPool(await investedProvider.getAddress(), params, sourcePoolId)
        expect(await investedProvider.poolIdToInvestId(poolId)).to.equal(investPoolId)
    })

    it("should return 0 when call getWithdrawableAmount", async () => {
        await mockInvestProvider.createInvestedPool(await investedProvider.getAddress(), params, sourcePoolId)
        expect(await investedProvider.getWithdrawableAmount(poolId)).to.equal(0)
    })

    it("should revert withdraw call", async () => {
        await expect(investedProvider.withdraw(amount)).to.be.revertedWith(
            "withdraw is not allowed for invested provider"
        )
    })

    it("should revert split call", async () => {
        await expect(investedProvider.split(poolId, sourcePoolId, amount)).to.be.revertedWith(
            "split is not allowed for invested provider"
        )
    })

    it("should return amount from getParams", async () => {
        await mockInvestProvider.createInvestedPool(await investedProvider.getAddress(), params, sourcePoolId)
        expect((await investedProvider.getParams(poolId)).toString()).to.equal([amount, investPoolId].toString())
    })

    it("should revert if caller is not approved", async () => {
        await expect(investedProvider.registerPool(poolId, [])).to.be.revertedWithCustomError(
            investedProvider,
            "InvalidProviderAddress"
        )
    })

    it("should revert invalid params length on register", async () => {
        const params = [amount, amount, amount]
        await expect(
            mockInvestProvider.createInvestedPool(await investedProvider.getAddress(), params, sourcePoolId)
        ).to.be.revertedWithCustomError(investedProvider, "InvalidParamsLength")
    })

    it("should revert invalid provider pool id", async () => {
        await expect(
            mockInvestProvider.callRegister(await investedProvider.getAddress(), params, sourcePoolId)
        ).to.be.revertedWithCustomError(investedProvider, "InvalidProviderPoolId")
    })

    it("should revert zero address lockDealNFT", async () => {
        const InvestedProvider = await ethers.getContractFactory("InvestedProvider")
        await expect(InvestedProvider.deploy(ethers.ZeroAddress)).to.be.revertedWithCustomError(
            investedProvider,
            "ZeroAddress"
        )
    })
})
