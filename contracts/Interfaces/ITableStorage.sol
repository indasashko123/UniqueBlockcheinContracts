// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITableStorage
{
    function AddTable(uint8 table,uint16 payouts, address userAddress, uint userId, address key)external payable;
    function AddRewardSum(uint rewarderUserId, uint8 table, uint reward, address key )external payable;
    function AddReferalPayout(uint userId, uint rewardValue, address key)external payable;
    
    function ReducePayout(address key, uint8 table, uint userId) external payable;
    function PushTable(address key, uint8 table, address rewardAddress)external payable;
    function DeactiveTable(uint rewarderUserId,uint8 table, address key)external payable;
    function SwitchTablesQueue(uint8 table, address key)external payable;
    

    function GetFirstTableAddress(uint8 table)external view returns(address);
    function GetUserLevels(uint userId, uint tablesCount) external view returns (bool[] memory,uint16[] memory,uint16[] memory, uint[] memory);
    function IsTableActive(uint userId, uint8 tableNumber) external view returns (bool);
    function IsTableActiveOver(uint userId, uint8 table)external view returns(bool);
    function GetTablesCount(uint totalTables) external view returns (uint[] memory);
    function GetGlobalStatistic() external view returns(uint);
    function GetPlaceInQueue(uint userId, address userAddress, uint8 table,uint totalTables) external view returns(uint, uint);
    function GetUserRewards(uint userId) external view returns(uint, uint);
    function GetTablesQueue(uint8 table)external view returns(address[] memory);
    function GetHeadIndex(uint8 table)external view returns(uint);
   



}