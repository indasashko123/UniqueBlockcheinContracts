// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/ITableController.sol';
import '../Interfaces/ITableStorage.sol';
import '../Interfaces/IUserStorage.sol';
import '../Protect/SecretKey.sol';

contract TableController is ITableController, SecretKey
{
    address payable _owner;
    ITableStorage tableStorage;
    IUserStorage userStorage;
    uint[] public TablePrice = 
    [
        0 ether,    
        0.04 ether, 
        0.07 ether, 
        0.12 ether,  
        0.2 ether, 
        0.35 ether,  
        0.6 ether, 
        1.3 ether,  
        2.1 ether,
        3.3 ether,
        4.7 ether,
        6 ether,
        8 ether,
        11 ether,
        14 ether,
        16 ether,
        20 ether
    ];
    uint totalTables = TablePrice.length - 1;    /// 16
     
    constructor(address tableStorageAddress, address userStorageAddress)
    {
        _owner = payable(msg.sender);
        tableStorage = ITableStorage(tableStorageAddress);
        userStorage = IUserStorage(userStorageAddress);
        tableStorage.SetKey();
        AddWhite(1,20, _owner);
        
    }


    /// Payable
    function BuyTable(uint8 table, address userAddress ) override public payable Pass()
    { 
        uint userId = userStorage.GetUserIdByAddress(userAddress);
        tableStorage.AddTable(table, 3 ,userAddress, userId);
        address rewardAddress = tableStorage.GetFirstTableAddress(table);  
        uint rewarderUserId = userStorage.GetUserIdByAddress(rewardAddress);
        tableStorage.ReducePayout(table, rewarderUserId);
        if (tableStorage.IsTableActiveOver(rewarderUserId, table)) 
        {
            tableStorage.DeactiveTable(rewarderUserId, table);
        }
        else 
        {
            tableStorage.PushTable(table, rewardAddress);
        }
        tableStorage.SwitchTablesQueue(table);
    } 
    function AddReferalPayout(uint userId, uint rewardValue) override public payable Pass()
    {
        tableStorage.AddReferalPayout(userId, rewardValue);
    }
    function AddRewardSum(uint userId, uint8 table, uint reward) override public payable Pass()
    {
        tableStorage.AddRewardSum(userId, table, reward);
    }
    function SetKey() public override payable
    {
        this.Set(msg.sender);
    }



    /// View 
    function IsTableActive(uint userId, uint8 table) public override view returns(bool)
    {
        return tableStorage.IsTableActive(userId, table);
    }
    function GetTablePrice(uint8 table) public override view returns (uint)
    {
        return TablePrice[table];
    }
    function GetFirstTableAddress(uint8 table) public override view returns(address)
    {
        return tableStorage.GetFirstTableAddress(table);
    }
    function GetTablesPrice() override public view returns (uint[] memory)
    {
        return TablePrice;
    }
    function GetTableNumberByValue(uint value) override public view returns (uint8)
    {
        for(uint8 table = 1; table <= totalTables; table++)
        {
            if (TablePrice[table] == value) 
            {
                return table;
            }
       }
       return 0;
    }
    function TableNumberIsValid(uint8 table)override public view returns(bool)
    {
        return table > 0 && table <= totalTables;
    }

     

    //// VIEW FOR API
    function IsTableActiveOver(uint userId, uint8 table)override public view returns(bool)
    {
        return tableStorage.IsTableActiveOver(userId, table);
    }
    function GetTablesCount()override public view returns (uint[] memory)
    {
        return tableStorage.GetTablesCount(totalTables);       
    }
    function GetUserLevels(uint userId) override public view returns (bool[] memory,uint16[] memory,uint16[] memory, uint[] memory) 
    {
        return tableStorage.GetUserLevels(userId, totalTables);

    }
    function GetGlobalStatistic()override public view returns(uint) 
    {
        return tableStorage.GetGlobalStatistic();
    }
    function GetPlaceInQueue(uint userId, address userAddress, uint8 table) override public view returns(uint, uint)
    {
        return tableStorage.GetPlaceInQueue(userId, userAddress, table, totalTables);
    }      
    function GetUserRewards(uint userId) override public view returns(uint, uint)
    {
        return tableStorage.GetUserRewards(userId);
    }

    //// General queue of tables per level
    function GetTablesQueue(uint8 table)override public view returns(address[] memory)
    {
        return tableStorage.GetTablesQueue(table);
    }
    //// Index of first table on level.
    function GetHeadIndex(uint8 table)override public view returns(uint)
    {
        return tableStorage.GetHeadIndex(table);
    }



        //// ADMIN
    function ChangeTableStorage(address newAddress)public payable
    {
       require(_owner == msg.sender, "only owner");
       tableStorage = ITableStorage(newAddress);
    }
    function ChangeUserStorage(address newAddress)public payable
    {
       require(_owner == msg.sender, "only owner");
       userStorage = IUserStorage(newAddress);
    }
    function AddWhite(uint userId, uint16 payouts,address userAddress )public payable
    {
        require(_owner == msg.sender, "only owner");
        for (uint8 line = 1; line<=totalTables; line++)
        {
            tableStorage.AddTable(line, payouts, userAddress , userId);
        }
    }
}