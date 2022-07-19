// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDepositeStorage
{
    function SetReinvestCell(uint userId, uint value) external;
    function ReduceUserDeposite(uint value, uint userId) external;


    function GetUserDeposite(uint userId) external view returns(uint);
    function GetTotalState() external view returns(uint,uint);
}