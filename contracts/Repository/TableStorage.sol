// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/ITableStorage.sol';
import '../Protect/SecretKey.sol';

contract TableStorage is ITableStorage, SecretKey
{
    address payable _owner;

    struct UserTablesInfo 
    {
        uint16 activationTimes;
        uint16 payouts;
        bool active;
        uint rewardSum;              // Rewards From Table Rewards
    }
    struct UserTables
    {
        mapping(uint8 => UserTablesInfo) Tables;
        uint RewardSumForTables;
        uint ReferalRewards;
    }

    mapping (uint => UserTables) UserTablesById;             /// UserId => Tables for User
    mapping(uint8 => address[]) TablesQueue;                /// TableNumber => Users address in tables 
    mapping(uint8 => uint) headIndex;                       /// TablesNumber => first table in Queue
    uint public transactions;  // Transaction Counts
     
    constructor() 
    {       
        _owner = payable(msg.sender);
    }
    function AddTable(uint8 table, uint16 payouts, address UserAddress, uint userId)override public payable Pass()
    {   
        transactions++;
        UserTablesById[userId].Tables[table].activationTimes++;
        UserTablesById[userId].Tables[table].payouts = payouts;
        UserTablesById[userId].Tables[table].active = true;
        TablesQueue[table].push(UserAddress);
    } 
    function ReducePayout( uint8 table, uint userId) override public payable Pass()
    {
        UserTablesById[userId].Tables[table].payouts = UserTablesById[userId].Tables[table].payouts-1;
    }
    function AddRewardSum(uint rewarderUserId, uint8 table, uint reward )override public payable Pass()
    {
        UserTablesById[rewarderUserId].Tables[table].rewardSum += reward;
        UserTablesById[rewarderUserId].RewardSumForTables += reward;              
    }
    function PushTable( uint8 table, address rewardAddress)override public payable Pass()
    {
      
        TablesQueue[table].push(rewardAddress);
    }
    function DeactiveTable(uint rewarderUserId,uint8 table)override public payable Pass()
    {
        UserTablesById[rewarderUserId].Tables[table].active = false;
    }
    function SwitchTablesQueue(uint8 table)override public payable Pass()
    {
        delete TablesQueue[table][headIndex[table]];
        headIndex[table]++;
    }
    function AddReferalPayout(uint userId, uint rewardValue)override public payable Pass()
    {
        UserTablesById[userId].ReferalRewards += rewardValue;
    }
    function SetKey()public override payable
    {
        this.Set(msg.sender);
    }
    function ChangeKey(address newKey) public payable 
    {
        require(msg.sender == _owner, "2");
        this.Change(newKey);
    }
    /// VIEW

    //// General queue of tables per level
    function GetTablesQueue(uint8 table)override public view returns(address[] memory)
    {
        return TablesQueue[table];
    }
    //// Index of first table on level.
    function GetHeadIndex(uint8 table)override public view returns(uint)
    {
        return headIndex[table];
    }
    function IsTableActive(uint userId, uint8 tableNumber)override public view returns (bool)
    {
        return UserTablesById[userId].Tables[tableNumber].active;
    }
    function GetFirstTableAddress(uint8 table)override public view returns(address)
    {
        return TablesQueue[table][headIndex[table]];   
    }
    function IsTableActiveOver(uint userId, uint8 table)override public view returns(bool)
    {
        return UserTablesById[userId].Tables[table].payouts == 0;
    }
    function GetTablesCount(uint totalTables)override public view returns (uint[] memory)
    {
        uint lines = totalTables;  //16
        uint[] memory tablesCount = new uint[](totalTables +1);
        for(uint8 level = 1; level <= lines; level++)
        {
            tablesCount[level] = TablesQueue[level].length - headIndex[level];
        }
        return tablesCount;
    }
    function GetUserLevels(uint userId, uint totalTables)override public view returns (bool[] memory,uint16[] memory,uint16[] memory, uint[] memory) {
        bool[] memory active = new bool[](totalTables + 1);
        uint16[] memory payouts = new uint16[](totalTables + 1);
        uint16[] memory activationTimes = new uint16[](totalTables + 1);
        uint[] memory rewardSum = new uint[](totalTables + 1);
        for (uint8 level = 1; level <= totalTables; level++) 
        {
            active[level] = UserTablesById[userId].Tables[level].active;
            payouts[level] = UserTablesById[userId].Tables[level].payouts;
            activationTimes[level] = UserTablesById[userId].Tables[level].activationTimes;
            rewardSum[level] = UserTablesById[userId].Tables[level].rewardSum;
        }
        return (active, payouts, activationTimes, rewardSum);
    }
    function GetGlobalStatistic()override public view returns(uint) 
    {
        return transactions;
    }
    /// Номер в очереди, количество 
    function GetPlaceInQueue(uint userId, address userAddress, uint8 table, uint totalTables) override public view returns(uint, uint)
    {
        require(table > 0 && table <= totalTables, "Invalid level");

        // If user is not in the level queue
        if(!IsTableActive(userId, table))
        {
            return (0, 0);
        }

        uint place = 0;
        for(uint i = headIndex[table]; i < TablesQueue[table].length; i++) 
        {
            place++;
            if(TablesQueue[table][i] == userAddress) 
            {
                return (place, TablesQueue[table].length - headIndex[table]);   /// Место и всего столов в очереди
            }
        }
        // impossible case
        revert();
    }      
    function GetUserRewards(uint userId) override public view returns(uint, uint)
    {
        return (UserTablesById[userId].RewardSumForTables, UserTablesById[userId].ReferalRewards);
    }
}