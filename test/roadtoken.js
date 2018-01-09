//@Author : Mukesh Kumar

var RoadToken = artifacts.require("./RoadToken.sol");

contract('RoadToken', function(accounts) {

  it("Name of token should be \"RoadToken\"", function() {
    return RoadToken.deployed().then(function(instance) {
      return instance.name();
    }).then(function(nam) {
      assert.equal(nam.valueOf(), "Road Token", "The number of the token isn't \"Road Token\"");
    });
  });

  it("Symbol of token should be \"ROD\"", function() {
    return RoadToken.deployed().then(function(instance) {
      return instance.symbol();
    }).then(function(sym) {
      assert.equal(sym.valueOf(), "ROD", "The symbol of the token isn't \"ROD\"");
    });
  });

  it("Total supply should be 20 million", function() {
    return RoadToken.deployed().then(function(instance) {
      return instance._totalSupply();
    }).then(function(tot) {
      assert.equal(tot.valueOf(), 200000000e18, "The total supply isn't 20 million");
    });
  });

  it("Funder and key employees should hold 20% of the share", function() {
    return RoadToken.deployed().then(function(instance) {
      return instance._funderandKeyEmployees();
    }).then(function(fun) {
      assert.equal(fun.valueOf(), 40000000e18, "Funder and key employees don't hold 20% of the share");
    });
  });

  it("Advisor should hold 5% of the share", function() {
    return RoadToken.deployed().then(function(instance) {
      return instance._advisors();
    }).then(function(adv) {
      assert.equal(adv.valueOf(), 10000000e18, "Advisor don't hold 5% of the share");
    });
  });

  it("Individuals and marketplace incentive should be 5% of the share", function() {
    return RoadToken.deployed().then(function(instance) {
      return instance._induvidualandMarketplaceIncentive();
    }).then(function(ind) {
      assert.equal(ind.valueOf(), 10000000e18, "Individuals and marketplace incentive don't hold 5% of the share");
    });
  });

  it("Croudsale should hold 70% of the share", function() {
    return RoadToken.deployed().then(function(instance) {
      return instance._crowdsale();
    }).then(function(cro) {
      assert.equal(cro.valueOf(), 140000000e18, "Funder and key employees don't hold 70% of the share");
    });
  });

  it("Number of decimal places should be 18", function() {
    return RoadToken.deployed().then(function(instance) {
      return instance.decimals();
    }).then(function(deci) {
      assert.equal(deci.valueOf(), 18, "The number of decimal places wasn't 18");
    });
  });

  it("Price of 2500 RoadToken should be 1 wei", function() {
    return RoadToken.deployed().then(function(instance) {
      return instance.PRICE();
    }).then(function(deci) {
      assert.equal(deci.valueOf(), 2500, "Price of 2500 RoadTokens wasn't 1 wei");
    });
  });

  it("The minimum contribution should be 0.1 ether", function() {
    return RoadToken.deployed().then(function(instance) {
      return instance.minContribAmount();
    }).then(function(min) {
      assert.equal(min.valueOf(), 100000000000000000, "The minimum contribution isn't 0.1 ether");
    });
  });

   it("The Pre ICO maximum cap should be 100 ether", function() {
    return RoadToken.deployed().then(function(instance) {
      return instance._preICOmaxCap();
    }).then(function(pre) {
      assert.equal(pre.valueOf(), 100000000000000000000, "The Pre ICO maximum cap isn't be 100 ether");
    });
  });
  
  it("The soft cap should be a 5600 ether", function() {
    return RoadToken.deployed().then(function(instance) {
      return instance.softCap();
    }).then(function(sof) {
      assert.equal(sof.valueOf(), 5.6e+21, "The soft cap isn't be a 5600 ether");
    });
  });

  it("The max cap should be 56000 ether", function() {
    return RoadToken.deployed().then(function(instance) {
      return instance.maxCap();
    }).then(function(max) {
      assert.equal(max.valueOf(), 5.6e+22, "The max cap isnt 56000 ether");
    });
  });

  it("Pre ICO start time should be before Pre ICO end time", function() {
    var prestart, preend;
    return RoadToken.deployed().then(function(instance) {
      meta = instance;
      return  meta.preICOstartTime();
    }).then(function(start) {
        prestart = start.valueOf();
        return meta.preICOendTime();
    }).then(function(end){
        preend = end.valueOf();
        assert.equal(preend > prestart, true, "Pre ICO start time isn't before Pre ICO end time")
    });
  });

  it("Pre ICO start time should be after the current time", function() {
    var prestart, now;
    return RoadToken.deployed().then(function(instance) {
      meta = instance;
      return  meta.preICOstartTime();
    }).then(function(start) {
        prestart = start.valueOf();
        return meta.getNow();
    }).then(function(here){
        now = here.valueOf();
        assert.equal(now < prestart, true, "Pre ICO start time isn't after the current time")
    });
  });

  it("Pre ICO end time should be after the current time", function() {
    var preend, now;
    return RoadToken.deployed().then(function(instance) {
      meta = instance;
      return  meta.preICOendTime();
    }).then(function(end) {
        preend = end.valueOf();
        return meta.getNow();
    }).then(function(here){
        now = here.valueOf();
        assert.equal(now < preend, true, "Pre ICO end time isn't after the current time")
    });
  });

  it("ICO start time should be before ICO end time", function() {
    var start, end;
    return RoadToken.deployed().then(function(instance) {
      meta = instance;
      return  meta.startTime();
    }).then(function(start1) {
        start = start1.valueOf();
        return meta.endTime();
    }).then(function(end1){
        end = end1.valueOf();
        assert.equal(end > start, true, "ICO start time isn't before ICO end time")
    });
  });

  it("ICO start time should be after the current time", function() {
    var start, now;
    return RoadToken.deployed().then(function(instance) {
      meta = instance;
      return  meta.startTime();
    }).then(function(start1) {
        start = start1.valueOf();
        return meta.getNow();
    }).then(function(here){
        now = here.valueOf();
        assert.equal(now < start, true, "ICO start time isn't after the current time")
    });
  });

  it("ICO end time should be after the current time", function() {
    var end, now;
    return RoadToken.deployed().then(function(instance) {
      meta = instance;
      return  meta.preICOendTime();
    }).then(function(end1) {
        end = end1.valueOf();
        return meta.getNow();
    }).then(function(here){
        now = here.valueOf();
        assert.equal(now < end, true, "ICO end time isn't after the current time")
    });
  });

  it("ICO start time should be after Pre ICO start time", function() {
    var start, prestart;
    return RoadToken.deployed().then(function(instance) {
      meta = instance;
      return  meta.startTime();
    }).then(function(start1) {
        start = start1.valueOf();
        return meta.preICOstartTime();
    }).then(function(here){
        prestart = here.valueOf();
        assert.equal(prestart < start, true, "ICO start time isn't after pre ICO start time")
    });
  });

  it("ICO start time should be after Pre ICO end time", function() {
    var start, preend;
    return RoadToken.deployed().then(function(instance) {
      meta = instance;
      return  meta.startTime();
    }).then(function(start1) {
        start = start1.valueOf();
        return meta.preICOendTime();
    }).then(function(here){
        preend = here.valueOf();
        assert.equal(preend < start, true, "ICO start time isn't after pre ICO end time")
    });
  });

  it("ICO end time should be after Pre ICO start time", function() {
    var end, prestart;
    return RoadToken.deployed().then(function(instance) {
      meta = instance;
      return  meta.endTime();
    }).then(function(end1) {
        end = end1.valueOf();
        return meta.preICOstartTime();
    }).then(function(here){
        prestart = here.valueOf();
        assert.equal(prestart < end, true, "ICO end time isn't after pre ICO start time")
    });
  });

  it("ICO end time should be after Pre ICO end time", function() {
    var end, preend;
    return RoadToken.deployed().then(function(instance) {
      meta = instance;
      return  meta.endTime();
    }).then(function(end1) {
        end = end1.valueOf();
        return meta.preICOendTime();
    }).then(function(here){
        preend = here.valueOf();
        assert.equal(preend < end, true, "ICO end time isn't after pre ICO end time")
    });
  });


  it("getPrice method should return 2500", function() {
    return RoadToken.deployed().then(function(instance) {
      return instance.getPrice.call();
    }).then(function(price) {
      assert.equal(price.valueOf(), 2500, "getPrice method doesn't return 2500");
    });
  });

  it("totalSupply method should return 20 million", function() {
    return RoadToken.deployed().then(function(instance) {
      return instance.totalSupply.call();
    }).then(function(tot) {
      assert.equal(tot.valueOf(), 200000000e18, "getPrice method doesn't return 2500");
    });
  });
 
});
