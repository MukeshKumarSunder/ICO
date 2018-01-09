var ConvertLib = artifacts.require("./ConvertLib.sol");
var MetaCoin = artifacts.require("./MetaCoin.sol");
var RoadToken = artifacts.require("../contracts/RoadToken.sol");

module.exports = function(deployer) {
   deployer.deploy(ConvertLib);
   deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MetaCoin);
  var preICOstart=1508526000000;
  var preICOend=1508612400000;
  var ICOstart=1508698800000;
  var ICOend= 1509044400000;
  var muladdr= 0x68632053d86a0A60cae3607018A965597d3DFCaD;
  deployer.deploy(RoadToken, preICOstart, preICOend, ICOstart, ICOend, muladdr);
};
