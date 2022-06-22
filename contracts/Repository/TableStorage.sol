// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/ITableStorage.sol';


contract TableStorage is ITableStorage
{
    address payable _owner;
    mapping (address => bool) private SecretKey;

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
     
    constructor(address key) payable
    {       
        SecretKey[key] = true;
        _owner = payable(msg.sender);
    }
    function AddTable(uint8 table, uint16 payouts, address UserAddress, uint userId,address key)override public payable
    {   
        require(SecretKey[key], "1");
        transactions++;
        UserTablesById[userId].Tables[table].activationTimes++;
        UserTablesById[userId].Tables[table].payouts = payouts;
        UserTablesById[userId].Tables[table].active = true;
        TablesQueue[table].push(UserAddress);
    } 
    function AddRewardSum(uint rewarderUserId, uint8 table, uint reward, address key )override public payable
    {
        require(SecretKey[key], "1");
        UserTablesById[rewarderUserId].Tables[table].rewardSum += reward;
        UserTablesById[rewarderUserId].Tables[table].payouts--;
        UserTablesById[rewarderUserId].RewardSumForTables += reward;              
    }
    function PushTable(address key, uint8 table, address rewardAddress)override public payable
    {
        require(SecretKey[key], "1");
        TablesQueue[table].push(rewardAddress);
    }
    function DeactiveTable(uint rewarderUserId,uint8 table, address key)override public payable
    {
        require(SecretKey[key], "1");
        UserTablesById[rewarderUserId].Tables[table].active = false;
    }
    function SwitchTablesQueue(uint8 table,address key)override public payable
    {
        require(SecretKey[key], "1");
        delete TablesQueue[table][headIndex[table]];
        headIndex[table]++;
    }
    function AddReferalPayout(uint userId, uint rewardValue,address key)override public payable
    {
        require(SecretKey[key], "1");
        UserTablesById[userId].ReferalRewards += rewardValue;
    }

   //// Порядок :   1 AddTable, 2 PushTable, 3 SwitchTablesQueue






    /// VIEW
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
        return UserTablesById[userId].Tables[table].payouts <= 0;
    }
    function GetTablesCount(uint totalTables)override public view returns (uint[] memory)
    {
        uint[] memory tablesCount = new uint[](totalTables +1);
        for(uint8 level = 1; level <= totalTables; level++)
        {
            tablesCount[level] = TablesQueue[level].length-1 - headIndex[level];
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
    function GetGlobalStatistic()override public view returns(uint) {
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