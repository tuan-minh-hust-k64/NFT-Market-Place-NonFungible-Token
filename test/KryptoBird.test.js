const {assert} = require('chai');

const KryptoBird = artifacts.require('KryptoBird');

contract('KryptoBird', async accounts => {
    let contract;
    describe('Deployment', async () => {
        it('should be deployed successfully', async () => {
            contract = await KryptoBird.deployed();
            const address = contract.address;
            assert(!!address);
        })
        it('should return name of contract', async () => {
            const name = await contract.name();
            assert.equal(name, 'Kryptobird');
        })
        it('should return symbol of contract', async () => {
            const symbol = await contract.symbol();
            assert.equal(symbol, 'KBZ')
        })
        it('should be mint NFT successfully', async () => {
            await contract.mint('https:...1');
            let totalNFT = await contract.totalSupply();
            assert.equal(totalNFT.words[0], 1);
        })
        it('should be transfer NFT successfully', async () => {
            await contract.mint('https:...2');
            await contract.mint('https:...3');
            await contract.transferFrom(accounts[0], accounts[1], 1);
            let NFTOfAcc1 = await contract.balanceOf(accounts[1]);
            let NFTOfAcc0 = await contract.balanceOf(accounts[0])
            assert.equal(NFTOfAcc1.words[0], 1);
            assert.equal(NFTOfAcc0.words[0], 2);
        })
    })
})