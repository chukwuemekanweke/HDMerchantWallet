const Merchant = artifacts.require("Merchant");
const MerchantWallet = artifacts.require("MerchantWallet")

const owner = "0x20AB4EdaCeffD990CB4DDbd38A67Be9602471458"

module.exports = function (deployer) {
  deployer.deploy(Merchant);
  deployer.deploy(MerchantWallet, owner, owner)
};