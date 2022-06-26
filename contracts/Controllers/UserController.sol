// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IUserController.sol';
import '../Interfaces/IUserStorage.sol';
import "../Protect/SecretKey.sol";

contract UserController is IUserController, SecretKey
{
    address payable _owner;
    IUserStorage userStorage;
    uint[] public referralRewardPercents = 
    [
        0, 
        8, 
        4, 
        3, 
        2, 
        1, 
        1, 
        1  
    ];
    uint rewardableLinesCount = referralRewardPercents.length - 1;


    constructor (address userStorageAddress)
    {
       _owner = payable(msg.sender);
       userStorage = IUserStorage(userStorageAddress);
       userStorage.SetKey();
    }  

    function Register(address userAddress, uint refId) public override payable Pass()
    {  
        if (!IsUserExistById(refId))
        {
            refId = 1;
        }
        address refAddress = GetUserAddressById(refId);
        userStorage.AddUser(userAddress, refAddress);
        uint8 line = 1;
        address ref = refAddress;
        while (line <= rewardableLinesCount && ref != address(0)) 
        {
           userStorage.AddReferal(ref);
           ref = GetReferrer(ref);
           line++;
        }     
    }
    function SetKey() public override payable
    {
        this.Set(msg.sender);
    }

    
    ///// VIEW
    function IsUserExist(address addr) public override view returns(bool) ///
    {
        return userStorage.IsUserExist(addr);
    }
    function IsUserExistById(uint id) public override view returns (bool)  ///
    {
        return userStorage.IsUserExistById(id);
    }
    function GetUserByAddress(address userAddress) public override view returns (uint, address,uint)  ///
    {
        return userStorage.GetUserByAddress(userAddress);
    }
    function GetUserIdByAddress(address adr) public override view returns(uint)    ///
    {
        return userStorage.GetUserIdByAddress(adr);
    }
    function GetUserAddressById(uint userId) public override view returns (address)   ///
    {
        return userStorage.GetUserAddressById(userId);
    }
    function GetReferrer(address userAddress) public override view returns (address)   ///
    {
        return userStorage.GetReferrer(userAddress);
    }
    function GetReferalPercent(uint line) override public view returns(uint)   ///
    {
        return referralRewardPercents[line];
    }
    function GetUserById(uint id) public override view returns (uint, address,uint) ///
    {
        return userStorage.GetUserById(id);
    } 
    function GetMembersCount() public override view returns(uint)      ///
    {
        return userStorage.GetMembersCount();
    }
    function GetReferalLines() override public view returns(uint)   ///
    {
        return rewardableLinesCount;
    }
    function GetReferalPercentArray() override public view returns(uint[] memory)   ///
    {
        return referralRewardPercents;
    }


    //// ADMIN
    function ChangeStorage(address newAddress)public payable
    {
       require(_owner == msg.sender, "only owner");
       userStorage = IUserStorage(newAddress);
       userStorage.SetKey();
    }
}