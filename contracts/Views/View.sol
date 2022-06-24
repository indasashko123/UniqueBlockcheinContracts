// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IUserController.sol';
import '../Interfaces/ITableController.sol';
import '../Interfaces/IPullController.sol';
import '../Interfaces/IDepositeController.sol';

contract View
{
    IDepositeController deposite;
    IUserController user;
    ITableController table;
    IPullController pull;


    constructor(address userAd, address tableAd, address pullAd, address depAd)
    {
        user = IUserController(userAd);
        table = ITableController(tableAd);
        pull = IPullController(pullAd);
        deposite = IDepositeController(depAd);
    }


////   ID / REFERER / REFERALS COUNT / [ Table Rewards , Referal Rewards , USerDEposite] 
    function GetFullUserInfo(address userAddress) public view returns(uint, address, uint,  uint[] memory )
    {
        (uint userId, address Referer, uint referals) = user.GetUserByAddress(userAddress);
        uint userdeposite = deposite.GetUserDeposite(userId);
        (uint RewardsForTables, uint ReferalRewards) = table.GetUserRewards(userId);
        uint[] memory userFinance = new uint[](3);
        userFinance[0] = RewardsForTables;
        userFinance[1] = ReferalRewards;
        userFinance[2] = userdeposite;
       
        return 
        (
            userId, Referer, referals, userFinance
        );
    }

    /////   Tables Active  /  Payouts   /  activation Times   /   Table rewards   
    function GetUserLevels(uint userId) public view returns(bool[] memory, uint16[] memory,uint16[] memory, uint[] memory)
    {
         return  table.GetUserLevels(userId);
    }
    
    //// Place in Queue  /  Total Queue
    function GetTablePosition(uint userId, address userAddress, uint8 tableNumber) public view returns(uint, uint)
    {
        return table.GetPlaceInQueue(userId, userAddress, tableNumber);
    }

    

}


/*
function GetUserLevels(uint userId) override public view returns (bool[] memory,uint16[] memory,uint16[] memory, uint[] memory) 
 */