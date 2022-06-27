// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IPullStorage.sol';
import '../Protect/SecretKey.sol';
import "hardhat/console.sol";
contract PullStorage  is IPullStorage, SecretKey
{ 
     address payable private owner;
     struct GlobalStatistic
    {
        uint TotalPullsClose;
        uint TotalFoundSum;
        uint TotalRewards;
    }
    struct Member 
    {
        uint RewardsForPulls;
        uint RewardsFromRef;
        bool Active;
    }
    struct Pull
    {
        uint NeedToCollect;
        uint CollectedSum;
        uint TicketCount;
    }
    mapping (uint => Pull ) Pulls;   /// pullId => pull
    mapping (uint => Member) Members; /// uiserId => Member
    mapping (uint => mapping(uint => uint)) SumByUserId;  /// PullId =>  (userId => TicketSum)
    mapping (uint => mapping(uint => uint)) UserIdByNumber;  /// PullID =>  (TicketNumber  =>  userId)
    uint newPullId = 1;
    uint private FoundingSum;
    GlobalStatistic private globalStat;

   constructor(uint sum)
   {
        owner = payable(msg.sender);
        FoundingSum = sum;
        Pulls[newPullId] = Pull ({
            NeedToCollect : sum,
            CollectedSum : 0,
            TicketCount : 0
        }); 
   }

   function SetMember(uint UserId) override payable public Pass()
    {
        Members[UserId] = Member
        ({
            RewardsForPulls : 0,
            RewardsFromRef : 0,
            Active : true
        });   
    }
    function SetTicket( uint value, uint userId) override public payable Pass()
    {
        globalStat.TotalFoundSum += value;
        Pulls[newPullId].TicketCount++;
        UserIdByNumber[newPullId][Pulls[newPullId].TicketCount] = userId;
        SumByUserId[newPullId][userId] = value;
    }
    function AddToTicket(uint userId, uint value) override public payable Pass()
    {
        SumByUserId[newPullId][userId] += value;
    }
    function SetCurrentPullValue(uint value)  override public payable Pass()
    {
        Pulls[newPullId].CollectedSum += value;
    }
    function AddNewPull() override public payable Pass()
    {  
        newPullId++;
        Pulls[newPullId] = Pull ({
            NeedToCollect : FoundingSum,
            CollectedSum : 0,
            TicketCount : 0
        });        
        globalStat.TotalPullsClose ++;
    } 

    function AddMemberReferalRewards(uint value, uint UserId) override public payable Pass()
    {
        globalStat.TotalRewards += value;
        Members[UserId].RewardsFromRef += value;
    }
    function AddMemberRewards(uint value, uint UserId) override public payable Pass()
    {
        globalStat.TotalRewards += value;
        Members[UserId].RewardsForPulls += value;
    }
    function SetKey() public override payable
    {
        this.Set(msg.sender);
    }
    function ChangeKey(address newKey) public payable 
    {
        require(msg.sender == owner, "2");
        this.Change(newKey);
    }


    
    ///// VIEW 
    function TicketExistOnPull (uint userId, uint pullId) public override view returns(bool)
    {
        return SumByUserId[pullId][userId] != 0;
        //return [pullId][userId].UserId != 0;
    }
    function IsPullExist(uint id) override public view returns (bool)
    {
        return id <= newPullId;
    }
    function GetStatistic() override public view returns(uint,uint,uint)
    {
        return (
        globalStat.TotalPullsClose,
        globalStat.TotalFoundSum,
        globalStat.TotalRewards
        );
    }
    function IsMemberExist(uint id) override view public returns(bool)
    {
       return Members[id].Active;
    }
    function GetTicketCountOnPull(uint pullId) override public view returns(uint)
    {
        return Pulls[pullId].TicketCount;
    }
    function GetTicketsByPullId(uint pullId) override public view returns( uint[]memory,uint[]memory)
    {
        uint ticketsLength = Pulls[pullId].TicketCount;
        uint[] memory sum = new uint[](ticketsLength);
        uint [] memory userId =new uint[](ticketsLength);
        for (uint ticket=1; ticket <= ticketsLength; ticket++)
        {
            uint currentUserId = UserIdByNumber[pullId][ticket];
            sum[ticket-1] = SumByUserId[pullId][currentUserId];
            userId[ticket-1] = currentUserId;
        }
        return (sum,userId);
    }
    function GetTicketInfo(uint pullId, uint ticketNumber) override public view returns(uint, uint)
    {
        uint userId = UserIdByNumber[pullId][ticketNumber];
        return (userId, SumByUserId[pullId][userId]);
    }
    function GetLastCurrentPullSum() override public view returns (uint)
    {
        return Pulls[newPullId].NeedToCollect - Pulls[newPullId].CollectedSum;
    }
    function GetPullCollectedSum(uint pullId) override public view returns (uint)
    {
        return Pulls[pullId].CollectedSum;
    }
    function GetCurrentPull() override public view returns(uint,uint,uint)
    {
     return (
        Pulls[newPullId].NeedToCollect, 
        Pulls[newPullId].CollectedSum,
        Pulls[newPullId].TicketCount
        );
    }
    function GetPullsCount() public override view returns (uint) 
    {
        return newPullId;    
    }
    function GetMember(uint id ) override public view returns(uint,uint)
   {
       return (
        Members[id].RewardsForPulls, 
        Members[id].RewardsFromRef);
   }
   function GetPull(uint pullId) override public view returns(uint,uint,uint)
   {
       return
        (
        Pulls[pullId].NeedToCollect, 
        Pulls[pullId].CollectedSum,
        Pulls[pullId].TicketCount
        );
   }
   function GetStructure(uint pullId) public override view returns(uint,uint,uint, uint[] memory, uint[] memory)
   {
        uint ticketCount = Pulls[pullId].TicketCount;
        uint[] memory users = new uint[](ticketCount);
        uint[] memory sum = new uint[](ticketCount);
        for (uint tick = 1; tick <= ticketCount; tick++)
        {
            uint user = UserIdByNumber[pullId][tick];
            users[tick-1] = user;
            sum[tick-1]= SumByUserId[pullId][user];
        }
        return (Pulls[pullId].NeedToCollect, Pulls[pullId].CollectedSum, Pulls[pullId].TicketCount, users, sum );
   }
}