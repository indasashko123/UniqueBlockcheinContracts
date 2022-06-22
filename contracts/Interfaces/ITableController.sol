// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITableController 
{
    //// PAYABLE
    function BuyTable(uint8 table, address userAddress, uint userId, address key)external payable;
    function AddRewardSum(uint userId, uint8 table, uint reward, address key) external payable;
    function AddReferalPayout(uint userId,  uint rewardValue, address key)external payable;
    function OpenTable(uint8 table) external payable;
    function CloseTable(uint8 table) external payable;


    //// VIEW   
    function IsTableOpen(uint8 table) external view returns (bool);
    function TableNumberIsValid(uint8 table) external view returns (bool);
    function IsTableActive(uint userId, uint8 table) external view returns(bool);
    function GetTablePrice(uint8 table) external view returns (uint);
    function GetFirstTableAddress(uint8 table) external view returns(address);
    function GetTablesPrice() external view returns (uint[] memory);
    function GetTableNumberByValue(uint value)external view returns (uint8);
    function IsTableActiveOver(uint userId, uint8 table)external view returns(bool);
    function GetTablesCount()external view returns (uint[] memory);
    function GetUserLevels(uint userId)external view returns (bool[] memory,uint16[] memory,uint16[] memory, uint[] memory);
    function GetGlobalStatistic()external view returns(uint);
    function GetPlaceInQueue(uint userId, address userAddress, uint8 table)external view returns(uint, uint);
    function GetUserRewards(uint userId)external view returns(uint, uint);
}