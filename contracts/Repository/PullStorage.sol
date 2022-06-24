// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IPullStorage.sol';

contract PullStorage  is IPullStorage
{ 
    mapping (address => bool) private SecretKey;
    address payable private owner;
    struct Member 
    {
        uint SumDeposite;
        uint RewardsForPulls;
        uint RewardsFromRef;
    }
    struct Pull
    {
        uint id;
        uint CrowndFindingSum;
        uint CollectSum;
        uint LastFound;
    }
    struct Ticket
    {
        address userAddress;
        uint Sum;
        uint UserId;
    }
    struct GlobalStatistic
    {
        uint TotalPullsClose;
        uint TotalFoundSum;
        uint TotalRewards;
    }
    mapping (uint => Member) Members;     /// UserId => Member
    mapping (uint => Pull) Pulls;         /// PullId => Pull           
    mapping (uint => Ticket[]) Tickets;   /// PullId => Tickets;
    uint private newPullId = 1;
    uint private FoundingSum;
    GlobalStatistic private globalStat;

    constructor(address key, uint Sum )
    {
        SecretKey[key] = true;
        owner = payable(msg.sender);
        FoundingSum = Sum;
        Pull memory newPull = Pull
        ({
           id : newPullId,
           CrowndFindingSum : FoundingSum,
           CollectSum  : 0,
           LastFound : FoundingSum
        });
        Pulls[newPull.id] = newPull;
    }


    function SetMember(uint UserId, address key) override payable public 
    {
        require(SecretKey[key], "1");
        Members[UserId] = Member
        ({
            SumDeposite : 0,
            RewardsForPulls : 0,
            RewardsFromRef : 0
        });   
    }
    function SetTicket(address userAdr, uint value, uint userId, address key) override public payable
    {
        require(SecretKey[key], "1");
        globalStat.TotalFoundSum += value;
        Ticket memory ticket = Ticket
        ({
            userAddress : userAdr,
            Sum : value,
            UserId : userId
        });
        Tickets[Pulls[newPullId].id].push(ticket);
        
    }
    function AddMemberDeposite(uint userId, uint value, address key) override public payable
    {
        require(SecretKey[key], "1");
        Members[userId].SumDeposite += value;
    } 
    function SetCurrentPullValue(uint value, address key)  override public payable 
    {
        require(SecretKey[key], "1");
        Pulls[newPullId].CollectSum = Pulls[newPullId].CollectSum + value;
        Pulls[newPullId].LastFound = Pulls[newPullId].LastFound - value;
    }
    function AddNewPull(address key) override public payable 
    {  
        require(SecretKey[key], "1");
        Pull memory newPull = Pull
            ({
            id: ++newPullId,
            CrowndFindingSum : FoundingSum,
            CollectSum : 0,
            LastFound : FoundingSum
            });
        Pulls[newPull.id] = newPull;
        globalStat.TotalPullsClose ++;
    } 
    function AddMemberReferalRewards(uint value, uint UserId, address key) override public payable
    {
        require(SecretKey[key], "1");
        Members[UserId].RewardsFromRef = Members[UserId].RewardsFromRef + value;
    }
    function AddMemberRewards(uint value, uint UserId, address key) override public payable
    {
        require(SecretKey[key], "1");
        Members[UserId].RewardsForPulls = Members[UserId].RewardsForPulls + value;
    }




       ///// VIEW

    function IsPullExist(uint id) override public view returns (bool)
    {
        return Pulls[id].id != 0;
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
       return Members[id].SumDeposite != 0;
    }
    function GetTicketCountOnPull(uint pullId) override public view returns(uint)
    {
        Ticket[] memory ticket = Tickets[pullId];
        return ticket.length;
    }
    function GetTicketByPullId(uint pullId) override public view returns(address[] memory, uint[]memory,uint[]memory)
    {
        Ticket[] memory tickets = Tickets[pullId];
        address[] memory ticketAddreses;
        uint[] memory sum;
        uint [] memory userId;
        for (uint ticket; ticket<tickets.length;ticket++)
        {
            ticketAddreses[ticket] = tickets[ticket].userAddress;
            sum[ticket] = tickets[ticket].Sum;
            userId[ticket] = tickets[ticket].UserId;
        }
        return (ticketAddreses,sum,userId);
    }
    function GetTicketInfo(uint pullId, uint ticketNumber) override public view returns(address,uint,uint)
    {
        Ticket[] memory tickets = Tickets[pullId];
        Ticket memory ticket = tickets[ticketNumber-1]; 
        return 
        (
           ticket.userAddress,
           ticket.Sum,
           ticket.UserId
        );
    }
    function GetLastCurrentPullSum() override public view returns (uint)
    {
        return Pulls[newPullId].LastFound;
    }
    function GetPullCollectedSum(uint pullId) override public view returns (uint)
    {
        return Pulls[pullId].CrowndFindingSum;
    }
    function GetCurrentPull() override public view returns(uint,uint,uint,uint)
    {
        Pull memory CurrentPull = Pulls[newPullId];
     return (
        CurrentPull.id, 
        CurrentPull.CrowndFindingSum,
        CurrentPull.CollectSum,
        CurrentPull.LastFound);
    }
   function GetMember(uint id ) override public view returns(uint,uint,uint)
   {
       return (
        Members[id].SumDeposite, 
        Members[id].RewardsForPulls, 
        Members[id].RewardsFromRef);
   }
   function GetPull(uint pullId) override public view returns(uint,uint,uint,uint)
   {
       Pull memory pull = Pulls[pullId];
       return (pull.id, pull.CrowndFindingSum, pull.CollectSum,  pull.LastFound);
   }
}