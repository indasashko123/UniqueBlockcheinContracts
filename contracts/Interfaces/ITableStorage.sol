// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITableStorage
{
    function AddTable(uint8 table,uint16 payouts, address userAddress, uint userIdy)external payable;
    function AddRewardSum(uint rewarderUserId, uint8 table, uint reward)external payable;
    function AddReferalPayout(uint userId, uint rewardValue)external payable;
    function AddTotalValue(uint value) external payable;

    function ReducePayout(uint8 table, uint userId) external payable;
    function PushTable( uint8 table, address rewardAddress)external payable;
    function DeactiveTable(uint rewarderUserId,uint8 table)external payable;
    function SwitchTablesQueue(uint8 table)external payable;
    

    function GetFirstTableAddress(uint8 table)external view returns(address);
    function GetUserLevels(uint userId, uint tablesCount) external view returns (bool[] memory,uint16[] memory,uint16[] memory, uint[] memory);
    function IsTableActive(uint userId, uint8 tableNumber) external view returns (bool);
    function IsTableActiveOver(uint userId, uint8 table)external view returns(bool);
    function GetTablesCount(uint totalTables) external view returns (uint[] memory);
    function GetGlobalStatistic() external view returns(uint, uint);
    function GetPlaceInQueue(uint userId, address userAddress, uint8 table,uint totalTables) external view returns(uint, uint);
    function GetUserRewards(uint userId) external view returns(uint, uint);
    function GetTablesQueue(uint8 table)external view returns(address[] memory);
    function GetHeadIndex(uint8 table)external view returns(uint);
    function SetKey() external payable;



}