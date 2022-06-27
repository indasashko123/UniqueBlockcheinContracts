// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IPullController.sol';
import '../Interfaces/IPullStorage.sol';
import '../Interfaces/IUserStorage.sol';
import "../Protect/SecretKey.sol";

contract PullController is IPullController, SecretKey
{
    address payable owner;
    IPullStorage pullStorage;
    IUserStorage userStorage;

    constructor( address pullStorageAddress, address userStorageAddress)
    {
        owner = payable(msg.sender);
        pullStorage = IPullStorage(pullStorageAddress);
        userStorage = IUserStorage(userStorageAddress);
        pullStorage.SetKey();
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
    

    function BuyTicket(address userAddress, uint value) override public payable Pass()
    {
        uint userId = userStorage.GetUserIdByAddress(userAddress);
        if (!pullStorage.IsMemberExist(userId))
        {
            pullStorage.SetMember(userId);
        }
        uint lastValue = pullStorage.GetLastCurrentPullSum();
        uint pullId = pullStorage.GetPullsCount();
        bool existTicket = pullStorage.TicketExistOnPull(userId, pullId);       
        if (lastValue > value)
        {
            if(existTicket)
            {
                pullStorage.AddToTicket(userId, value);
            }
            else
            {
                pullStorage.SetTicket(userAddress, value,  userId);
            } 
            pullStorage.AddMemberDeposite(userId, value);
            pullStorage.SetCurrentPullValue(value);
        }
        else
        {
            uint residual = value - lastValue;
            if (existTicket)
            {
                pullStorage.AddToTicket(userId, lastValue);
            }
            else
            {
                pullStorage.SetTicket(userAddress, lastValue,  userId);
            }    
            pullStorage.SetCurrentPullValue(lastValue);
            pullStorage.AddNewPull();
            if (residual > 0)
            {
                pullStorage.SetTicket(userAddress, residual,  userId);
                pullStorage.SetCurrentPullValue(residual);
                pullStorage.AddMemberDeposite(userId, value);
            }

        }
    }
    function AddMemberReferalRewards(uint value, uint UserId ) override public payable Pass()
    {
        pullStorage.AddMemberReferalRewards(value, UserId );
    }
    function AddMemberRewards(uint value, uint UserId ) override public payable Pass()
    {
        pullStorage.AddMemberRewards(value, UserId);
    }
    function SetKey() public override payable
    {
        this.Set(msg.sender);
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
    function GetStatistic() public override view returns(uint,uint, uint)
    {
        return pullStorage.GetStatistic();
    }
    function GetCurrentPull() override public view returns(uint,uint,uint,uint)
    {
        return pullStorage.GetCurrentPull();
    }
    function GetPull(uint pullId) override public view returns(uint,uint,uint,uint)
    {
        return pullStorage.GetPull(pullId);
    }
    function GetMember(uint userId) public override view returns(uint,uint,uint)
    {
        return pullStorage.GetMember(userId);
    }
    function GetTicketsByPullId(uint pullId) public override view returns(address[] memory,uint [] memory, uint[] memory)
    {
        return pullStorage.GetTicketByPullId(pullId);
    }
    function GetPullCount()public override view returns(uint)
    {
        return pullStorage.GetPullsCount();
    }


        //// ADMIN
    function ChangePullStorage(address newAddress)public payable
    {
       require(owner == msg.sender, "only owner");
       pullStorage = IPullStorage(newAddress);
       pullStorage.SetKey();
    }
    function ChangeUserStorage(address newAddress)public payable
    {
       require(owner == msg.sender, "only owner");
       userStorage = IUserStorage(newAddress);
    }
}