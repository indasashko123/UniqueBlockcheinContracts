// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IDepositeController.sol';
import '../Interfaces/IDepositeStorage.sol';

contract DepositeController is IDepositeController
{
    address payable owner;
    mapping (address => bool) private SecretKey;

    IDepositeStorage depositeStorage;

    constructor (address key, address depositeStorageAddress)
    {
        owner = payable(msg.sender);
        SecretKey[key] = true; 
        depositeStorage = IDepositeStorage(depositeStorageAddress);
    }


    function SetReinvestCell(uint userId, uint value, address key) override public payable
    {
        require(SecretKey[key],"1");
        depositeStorage.SetReinvestCell(userId, value, key);
    }
    function ReduceUserDeposite(uint value, uint userId, address key) override public payable
    {
        require(SecretKey[key],"1");
        depositeStorage.ReduceUserDeposite(value, userId, key);
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
    function ChangeDeposteStorage(address newAddress, address key)public payable
    {
       require(SecretKey[key], "1");
       require(owner == msg.sender, "only owner");
       depositeStorage = IDepositeStorage(newAddress);
    }
}