// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IDepositeStorage.sol';
import '../Protect/SecretKey.sol';

contract DepositeStorage is  IDepositeStorage, SecretKey
{
    address payable owner;
    mapping (uint => uint) UserSum;           /// UserId => deposite
    uint TotalValueCount;
    uint TotalReinvests;
    
    constructor()
    {
        owner = payable(msg.sender);
    }



    function SetReinvestCell(uint userId, uint value) public override payable Pass()
    {
        UserSum[userId] += value;
        TotalValueCount += value;
    }
    function ReduceUserDeposite(uint value, uint userId) public override payable Pass()
    {
        UserSum[userId] -= value;
        TotalValueCount -= value;
    }
    function SetKey() payable override public 
    {
        this.Set(msg.sender);
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

    function ChangeKey(address newKey) public payable 
    {
        require(msg.sender == owner, "2");
        this.Change(newKey);
    }
}