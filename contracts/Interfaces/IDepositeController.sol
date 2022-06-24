// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDepositeController
{
    function SetReinvestCell(uint userId, uint value, address key) external payable;
    function ReduceUserDeposite(uint value, uint userId, address key) external payable;

    function GetUserDeposite(uint userId) external view returns(uint);
    function GetTotalState() external view returns(uint,uint);
}