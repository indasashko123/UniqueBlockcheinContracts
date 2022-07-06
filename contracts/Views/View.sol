// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IUserController.sol';
import '../Interfaces/ITableController.sol';
import '../Interfaces/IPullController.sol';
import '../Interfaces/IDepositeController.sol';

contract View
{
    IDepositeController deposite;
    IUserController user;
    ITableController table;
    IPullController pull;


    constructor(address userAd, address tableAd, address pullAd, address depAd)
    {
        user = IUserController(userAd);
        table = ITableController(tableAd);
        pull = IPullController(pullAd);
        deposite = IDepositeController(depAd);
    }

         //// USERS
    /*
        [
            uint : Id,
            Address : Referrer,
            uint : ReferalCount,
            [
                uint : tableRewards,
                uint : ReferalRewards,
                uint : UserDeposite,
                uint : PullReward,
                uint : PullReferalReward
            ]
        ]
    */
    function GetFullUserInfo(address userAddress) public view returns(uint, address, uint,  uint[] memory )
    {
        (uint userId, address Referer, uint referals) = user.GetUserByAddress(userAddress);
        uint userdeposite = deposite.GetUserDeposite(userId);
        (uint RewardsForTables, uint ReferalRewards) = table.GetUserRewards(userId);
        uint[] memory userFinance = new uint[](5);
        (uint pullReward, uint pullRefReward) = pull.GetMember(userId);
        userFinance[0] = RewardsForTables;
        userFinance[1] = ReferalRewards;
        userFinance[2] = userdeposite;
        userFinance[3] = pullReward;
        userFinance[4] = pullRefReward;
       
        return 
        (
            userId, Referer, referals, userFinance
        );
    }                                      
    /*
       [
         bool[] : ActiveTable,
         uint[] : Payouts,
         uint[] : ActivationTimes,
         uint[] : TableRewards
       ]
    */
    function GetUserLevels(uint userId) public view returns(bool[] memory, uint16[] memory,uint16[] memory, uint[] memory)
    {
        return table.GetUserLevels(userId);
    }
    function GetUserId(address userAddress) public view returns(uint)
    {
        return user.GetUserIdByAddress(userAddress);
    }
    
                                   /// TABLE    
    /*
       [
         uint : place,
         uint : totalQueue
       ]
    */
    function GetTablePosition(uint userId, address userAddress, uint8 tableNumber) public view returns(uint, uint)
    {
        return table.GetPlaceInQueue(userId, userAddress, tableNumber);
    }

    /// PULLS
    /*
      [
        uint : NeedToCollect,
        uint : CollectedNow,
        uint : LastToCollect
      ]
    */
    function GetPullById(uint pullId) public view returns(uint,uint, uint)
    {
        return  pull.GetPull(pullId);
    }
    function GetPullCount() public view returns(uint)
    {
        return pull.GetPullCount();
    }
    /*
       [
         uint ; userId,
         uint : sum
       ]
    */
    function GetTicketInfo(uint pullId, uint ticketNumber) public view returns (uint, uint)
    {
        return pull.GetTicketInfo(pullId, ticketNumber);
    }
    function GetTicketCount(uint pullId) public view returns(uint)
    {
        return pull.GetTicketCountOnPull(pullId);
    }
    function GetData(address userAddress) public view returns (uint,uint)
    {
        uint userId = user.GetUserIdByAddress(userAddress);
        (bool[] memory actives, uint16[] memory payouts, uint16[] memory activationTimes, uint[] memory rewards) = table.GetUserLevels(userId);
        uint activation = 0;
        for (uint level = 1; level < activationTimes.length; level++ )
        {
            if (activationTimes[level] == 0)
            {
                break;
            }
            activation += activationTimes[level];
        } 
        (uint id, address ref, uint referals) = user.GetUserById(userId);
        return (referals, activation);
    }

    /*
         [
            uint : NeedToCollect,
            uint : CollectedSum,
            uint : TicketCount,
            uint[] : usersId,
            uint[] : ticketsSum
         ]
     */
    function GetStructure(uint pullId) public view returns(uint,uint,uint, uint[] memory, uint[] memory)
    {
        return pull.GetStructure(pullId);
    }
    

    /*
       [
          user count,
          transactionsCount 
          total found on pulls
          total value on tables
          pull count
          total pull rewads
       ]
    */
    function GetGlobalInfo()public view returns(uint,uint,uint,uint,uint, uint)
    {
        uint UserCount = user.GetMembersCount();
        (uint Transactions, uint TotalValue ) = table.GetGlobalStatistic();
        (uint PullCount, uint TotalFound, uint TotalRewardsPull) = pull.GetStatistic();
        return (UserCount, Transactions, TotalFound, TotalValue, PullCount,TotalRewardsPull);
       
    }
}
