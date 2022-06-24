// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IPullController.sol';
import '../Interfaces/IPullStorage.sol';
import '../Interfaces/IUserStorage.sol';

contract PullController is IPullController
{
    mapping (address => bool) private SecretKey;
    address payable owner;
    IPullStorage pullStorage;
    IUserStorage userStorage;

    constructor(address key, address pullStorageAddress, address userStorageAddress)
    {
        SecretKey[key] = true;
        owner = payable(msg.sender);
        pullStorage = IPullStorage(pullStorageAddress);
        userStorage = IUserStorage(userStorageAddress);
    }
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
    uint public rewardableLinesCount = referralRewardPercents.length - 1;
    




    function BuyTicket(address userAddress, uint value, address key) override public payable
    {
        require(SecretKey[key], "1");
        uint userId = userStorage.GetUserIdByAddress(userAddress);
        if (!pullStorage.IsMemberExist(userId))
        {
            pullStorage.SetMember(userId, key);
        }
        uint lastValue = pullStorage.GetLastCurrentPullSum();
        if (lastValue > value)
        {
            pullStorage.SetTicket(userAddress, value,  userId,  key);
            pullStorage.AddMemberDeposite(userId, value, key);
            pullStorage.SetCurrentPullValue(value, key);
        }
        else
        {
            uint residual = value - lastValue;
            pullStorage.SetTicket(userAddress, lastValue,  userId,  key);
            pullStorage.SetCurrentPullValue(lastValue, key);
            pullStorage.AddNewPull(key);
            if (residual > 0)
            {
                pullStorage.SetTicket(userAddress, residual,  userId,  key);
                pullStorage.SetCurrentPullValue(residual, key);
                pullStorage.AddMemberDeposite(userId, value, key);
            }

        }
    }
    function AddMemberReferalRewards(uint value, uint UserId, address key) override public payable
    {
        require(SecretKey[key], "1");
        pullStorage.AddMemberReferalRewards(value, UserId, key);
    }
    function AddMemberRewards(uint value, uint UserId, address key) override public payable
    {
        require(SecretKey[key], "1");
        pullStorage.AddMemberRewards(value, UserId, key);
    }




    function GetRewardableLines() override public view returns(uint[] memory)
    {
        return referralRewardPercents;
    }
    function IsPullExist(uint id) override public view returns (bool)
    {
        return pullStorage.IsPullExist(id);
    }
    function GetTicketCountOnPull(uint pullId) override public view returns(uint)
    {
        return pullStorage.GetTicketCountOnPull(pullId);
    }
    function GetPullCollectedSum(uint pullId)  override public view returns (uint)
    {
        return pullStorage.GetPullCollectedSum(pullId);
    }
    function GetTicketInfo(uint pullId, uint ticketNumber) override public view returns(address,uint,uint)
    {
        return pullStorage.GetTicketInfo(pullId, ticketNumber);
    }

    function GetCurrentPull() override public view returns(uint,uint,uint,uint)
    {
        return pullStorage.GetCurrentPull();
    }
    function GetPull(uint pullId) override public view returns(uint,uint,uint,uint)
    {
        return pullStorage.GetPull(pullId);
    }


        //// ADMIN
    function ChangePullStorage(address newAddress, address key)public payable
    {
       require(SecretKey[key], "1");
       require(owner == msg.sender, "only owner");
       pullStorage = IPullStorage(newAddress);
    }
    function ChangeUserStorage(address newAddress, address key)public payable
    {
       require(SecretKey[key], "1");
       require(owner == msg.sender, "only owner");
       userStorage = IUserStorage(newAddress);
    }
}