// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IDepositeStorage.sol';

contract DepositeStorage is IDepositeStorage
{
    mapping (address => bool) private SecretKey;
    address payable owner;
    mapping (uint => uint) UserSum;           /// UserId => deposite
    uint TotalValueCount;
    uint TotalReinvests;
    
    constructor(address key)
    {
        owner = payable(msg.sender);
        SecretKey[key] = true;
    }



    function SetReinvestCell(uint userId, uint value, address key) public override payable
    {
        require(SecretKey[key],"1");
        UserSum[userId] += value;
        TotalValueCount += value;
    }
    function ReduceUserDeposite(uint value, uint userId, address key) public override payable
    {
        require(SecretKey[key],"1");
        UserSum[userId] -= value;
        TotalValueCount -= value;
    }


    //// VIEW
    function GetUserDeposite(uint userId) override public view returns(uint)
    {
        return UserSum[userId];
    }
    function GetTotalState() public override view returns(uint,uint)
    {
        return (TotalValueCount, TotalReinvests);
    }
}