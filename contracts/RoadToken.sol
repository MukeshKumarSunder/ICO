pragma solidity ^0.4.8;
library SafeMath {
    function mul(uint256 a, uint256 b) internal constant returns (uint256) {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal constant returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal constant returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal constant returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract IERC20
{

    function totalSupply() public constant returns (uint256);
    function balanceOf(address _to) public constant returns (uint256);
    function transfer(address to, uint256 value) public;
    function transferFrom(address from, address to, uint256 value);
    function approve(address spender, uint256 value) public;
    function allowance(address owner, address spender) public constant returns (uint256);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

}

contract RoadToken is IERC20{

    using SafeMath for uint256;
    
    enum Stage {PREICO, ICO}
    
    // Token properties
    string public name = "Road Token";
    string public symbol = "ROD";
    uint public decimals = 18;

    uint public _totalSupply = 200000000e18;

    uint public _funderandKeyEmployees = 40000000e18;

    uint public _advisors = 10000000e18;

    uint public _induvidualandMarketplaceIncentive =10000000e18;

    uint public _crowdsale = 140000000e18;


    //total sold token
    uint public totaldistribution=0;

    // Balances for each account
    mapping (address => uint256) balances;

    // Owner of account approves the transfer of an amount to another account
    mapping (address => mapping(address => uint256)) allowed;

    // List of all token holders with their tokens
    mapping(uint => address) public indexes;

    uint public topindex;

    // start and end timestamps where investments are allowed (both inclusive)
    uint256 public preICOstartTime;
    uint256 public preICOendTime;

    // start and end timestamps where investments are allowed (both inclusive)
    uint256 public startTime;
    uint256 public endTime;
    
    //stage preICO or ICO
    Stage public stage;
     
    // Owner of Token
    address public owner;

    // Wallet Address of Token
    address public multisig;

    // how many token units a buyer gets per wei
    uint public PRICE = 2500;

    uint public minContribAmount = 0.1 ether; // 0.1 ether
    
    
    uint public _preICOmaxCap = 100 ether;
    
    uint public softCap = 5600 ether;

    uint public maxCap = 56000 ether;

    // amount of raised money in wei
    uint256 public fundRaised;

      // modifier to allow only owner has full control on the function
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    // Constructor
    // @notice RoadToken Contract
    // @return the transaction address
    function RoadToken(uint256 _preICOstartTime, uint256 _preICOendTime,uint256 _startTime, uint256 _endTime, address _multisig) public payable {
        require(_startTime >= getNow() && _endTime >= _startTime && _multisig != 0x0);
        preICOstartTime = _preICOstartTime;
        preICOendTime = _preICOendTime;
        startTime = _startTime;
        endTime = _endTime;
        multisig = _multisig;
        balances[multisig] = _totalSupply;
        stage = Stage.PREICO;
        owner=msg.sender;
        topindex = 0;
        indexes[topindex] = multisig;
    }


    // Payable method
    // @notice Anyone can buy the tokens on tokensale by paying ether
    function () public payable {
        tokensale(msg.sender);
    }

    // @notice tokensale
    // @param recipient The address of the recipient
    // @return the transaction address and send the event as Transfer
    function tokensale(address _to) public payable {
        require(_to != 0x0);
        require(validPurchase());

        uint256 weiAmount = msg.value;
        uint tokens = weiAmount.mul(getPrice());
        uint timebasedBonus = tokens.mul(getTimebasedBonusRate()).div(100);

        uint volumebasedBonus = tokens.mul(getVolumebasedBonusRate(weiAmount)).div(100);

        tokens = tokens.add(timebasedBonus);

        tokens = tokens.add(volumebasedBonus);
        require (tokens < _crowdsale);

        if (balances[_to] == 0) {
            topindex = topindex.add(1);
            indexes[topindex] = _to;
        }

        fundRaised = fundRaised.add(weiAmount);
        balances[multisig] = balances[multisig].sub(tokens);
        balances[_to] = balances[_to].add(tokens);
        _crowdsale = _crowdsale.sub(tokens);

        totaldistribution = totaldistribution.add(tokens);

        forwardFunds();
    }

    // send ether to the fund collection wallet
    // override to create custom fund forwarding mechanisms
    function forwardFunds() internal {
        multisig.transfer(msg.value);
    }

    // @return true if the transaction can buy tokens
    function validPurchase() internal constant returns (bool) {
        
         bool withinPeriod = false;
         bool notReachedMaxCap = false;
        //check and change stage
        if (stage == Stage.PREICO && getNow() > preICOendTime && getNow() > startTime) {
            stage = Stage.ICO;
        }
        
        if (stage == Stage.PREICO) {
            withinPeriod = getNow() >= preICOstartTime && getNow() <= preICOendTime;
            notReachedMaxCap = _preICOmaxCap >= fundRaised;
        } else {
            withinPeriod = getNow() >= startTime && getNow() <= endTime;
            notReachedMaxCap = maxCap >= fundRaised;
        }
        
        bool nonZeroPurchase = msg.value != 0;
        bool minContribution = minContribAmount <= msg.value;
        return withinPeriod && nonZeroPurchase && minContribution && notReachedMaxCap;
    }
    
     function getTimebasedBonusRate() internal constant returns (uint256) {
        uint256 bonusRate = 0;
        uint nowTime = getNow();
        uint hrs24 = startTime + (24 hours * 1000);
        uint week1 = startTime + (7 days * 1000);
        uint week2 = startTime + (14 days * 1000);
        uint week3 = startTime + (21 days *1000);
        if (nowTime <= hrs24) {
            bonusRate = 20;
        } else if (nowTime <= week1) {
            bonusRate = 15;
        } else if (nowTime <= week2) {
            bonusRate =10;
        }
            else if (nowTime <= week3) {
            bonusRate =5;
        }

        return bonusRate;
    }

    function getVolumebasedBonusRate(uint256 value) internal constant returns (uint256) {
        uint256 bonusRate = 0;
        uint valume = value.div(1 ether);

        if (valume <= 10 && valume >= 5) {
            bonusRate = 2;
        } else if (valume <= 50 && valume >= 11) {
            bonusRate = 3;
        } else if (valume <= 500 && valume >= 51) {
            bonusRate = 5;
        } else if (valume >= 501) {
            bonusRate = 10;
        }

        return bonusRate;
    }

    // Updated Next Stage  and start and end date
    function updateICOStage(uint256 _startTime, uint256 _endTime) onlyOwner  {
        require(hasEnded());
        require(_startTime >= getNow());
        require(_endTime >= _startTime);
     
        stage = Stage.ICO;
        startTime = _startTime;
        endTime = _endTime;
       
    }


    // @return total tokens supplied
    function totalSupply() public constant returns (uint256) {
        return _totalSupply;
    }

    // What is the balance of a particular account?
    // @param who The address of the particular account
    // @return the balanace the particular account
    function balanceOf(address _to) public constant returns (uint256) {
        return balances[_to];
    }


    // Token distribution to 40000000 will go the funderandKeyEmployees
    function sendFunderandKeyEmployees(address to, uint256 value) public onlyOwner {
        require (
            to != 0x0 && value > 0 && _funderandKeyEmployees >= value
        );

        balances[multisig] = balances[multisig].sub(value);
        balances[to] = balances[to].add(value);
        _funderandKeyEmployees = _funderandKeyEmployees.sub(value);
        Transfer(multisig, to, value);
    }

    //Token Distribution 10000000 will go the ROAD advisors
    function sendAdvisorsFundSupplyToken(address to, uint256 value) public onlyOwner {
        require (
            to != 0x0 && value > 0 && _advisors >= value);

        balances[multisig] = balances[multisig].sub(value);
        balances[to] = balances[to].add(value);
        _advisors = _advisors.sub(value);
        Transfer(multisig, to, value);
    }

    //Token Distribution 10000000 will go to induvidual and MarketplaceIncentive

    function sendInduvidualandMarketplaceIncentiveFundSupplyToken(address to, uint256 value) public onlyOwner {
        require (
            to != 0x0 && value > 0 && _induvidualandMarketplaceIncentive >= value
        );

        balances[multisig] = balances[multisig].sub(value);
        balances[to] = balances[to].add(value);
        _induvidualandMarketplaceIncentive = _induvidualandMarketplaceIncentive.sub(value);
        Transfer(multisig, to, value);
    }

    // @notice send `value` token to `to` from `msg.sender`
    // @param to The address of the recipient
    // @param value The amount of token to be transferred
    // @return the transaction address and send the event as Transfer
    function transfer(address to, uint256 value) public {
        require (
            balances[msg.sender] >= value && value > 0
        );
        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value);
        Transfer(msg.sender, to, value);
    }


    // @notice send `value` token to `to` from `from`
    // @param from The address of the sender
    // @param to The address of the recipient
    // @param value The amount of token to be transferred
    // @return the transaction address and send the event as Transfer
    function transferFrom(address from, address to, uint256 value) public {
        require (
            allowed[from][msg.sender] >= value && balances[from] >= value && value > 0
        );
        balances[from] = balances[from].sub(value);
        balances[to] = balances[to].add(value);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
        Transfer(from, to, value);
    }

    // Allow spender to withdraw from your account, multiple times, up to the value amount.
    // If this function is called again it overwrites the current allowance with value.
    // @param spender The address of the sender
    // @param value The amount to be approved
    // @return the transaction address and send the event as Approval
    function approve(address spender, uint256 value) public {
        require (
            balances[msg.sender] >= value && value > 0
        );
        allowed[msg.sender][spender] = value;
        Approval(msg.sender, spender, value);
    }

    // Check the allowed value for the spender to withdraw from owner
    // @param owner The address of the owner
    // @param spender The address of the spender
    // @return the amount which spender is still allowed to withdraw from owner
    function allowance(address _owner, address spender) public constant returns (uint256) {
        return allowed[_owner][spender];
    }


    // Get current price of a Token
    // @return the price or token value for a ether
    function getPrice() public constant returns (uint result) {
        return PRICE;
    }

    // change the _totalSupply
    // @param _totalSupply
    function changeTotalsupply(uint256 totalsupply) public onlyOwner {
       _totalSupply = totalsupply;
    }

    // @return true if crowdsale current lot event has ended
    function hasEnded() public constant returns (bool) {
        return getNow() > endTime;
    }
       // @return  current time
    function getNow() public constant returns (uint) {
        return (now * 1000);
    }

}
