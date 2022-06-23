// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IUserController.sol';
import '../Interfaces/IUserStorage.sol';


contract UserController is IUserController
{
    address payable _owner;
    mapping (address => bool) private SecretKey;
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


    constructor (address key, address userStorageAddress)
    {
       SecretKey[key] = true;
       _owner = payable(msg.sender);
       userStorage = IUserStorage(userStorageAddress);
    }  

    function Register(address key, address userAddress, uint refId) public override payable 
    {  
        require(SecretKey[key], "1");
        if (!IsUserExistById(refId))
        {
            refId = 1;
        }
        address refAddress = GetUserAddressById(refId);
        userStorage.AddUser(userAddress, refAddress, key);
        uint8 line = 1;
        address ref = refAddress;
        while (line <= rewardableLinesCount && ref != address(0)) 
        {
           userStorage.AddReferal(ref, key);
           ref = GetReferrer(ref);
           line++;
        }     
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
    function ChangeStorage(address newAddress, address key)public payable
    {
       require(SecretKey[key], "1");
       require(_owner == msg.sender, "only owner");
       userStorage = IUserStorage(newAddress);
    }
}