// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IKeyStorage
{
    function ADD(uint _value) external payable;
    function REDUSE(uint _value) external payable;

    function GET() external view returns(uint);
    function SetKey() external payable;
}