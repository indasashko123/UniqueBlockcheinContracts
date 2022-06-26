// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IDepositeController.sol';
import '../Interfaces/IDepositeStorage.sol';
import '../Protect/SecretKey.sol';


contract DepositeController is SecretKey, IDepositeController
{
    address payable owner;
    IDepositeStorage depositeStorage;

    constructor ( address depositeStorageAddress)
    {
        owner = payable(msg.sender);
        depositeStorage = IDepositeStorage(depositeStorageAddress);
        depositeStorage.SetKey();
    }


    function SetReinvestCell(uint userId, uint value) override public payable Pass()
    {
        depositeStorage.SetReinvestCell(userId, value);
    }
    function ReduceUserDeposite(uint value, uint userId) override public payable Pass()
    {
        depositeStorage.ReduceUserDeposite(value, userId);
    }
    function SetKey() public payable override
    {
        this.Set(msg.sender);
    }

    function GetUserDeposite(uint userId) public override view returns(uint)
    {
        return depositeStorage.GetUserDeposite(userId);
    }
    function GetTotalState() public override view returns(uint,uint)
    {
        return depositeStorage.GetTotalState();
    }


    //// ADMIN
    function ChangeDeposteStorage(address newAddress)public payable
    {
       require(owner == msg.sender, "only owner");
       depositeStorage = IDepositeStorage(newAddress);
    }
}