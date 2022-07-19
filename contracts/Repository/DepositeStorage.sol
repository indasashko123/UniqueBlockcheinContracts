// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IDepositeStorage.sol';


contract DepositeStorage is  IDepositeStorage
{
    address payable owner;
    mapping (uint => uint) UserSum;           /// UserId => deposite
    uint TotalValueCount;
    uint TotalReinvests;
    
    constructor()
    {
        owner = payable(msg.sender);
    }



    function SetReinvestCell(uint userId, uint value) public override 
    {
        UserSum[userId] += value;
        TotalValueCount += value;
    }
    function ReduceUserDeposite(uint value, uint userId) public override 
    {
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