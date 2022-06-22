// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/ITableController.sol';
import '../Interfaces/ITableStorage.sol';
import '../Interfaces/IUserStorage.sol';


contract TableController is ITableController
{
    address payable _owner;
    mapping (address => bool) private SecretKey;
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
    uint totalTables = TablePrice.length - 1; 
    mapping (uint8 => bool) OpenedTables;    /// table number => open/close
     
    constructor(address key, address tableStorageAddress, address userStorageAddress)
    {
        _owner = payable(msg.sender);
        SecretKey[key] = true;
        tableStorage = ITableStorage(tableStorageAddress);
        userStorage = IUserStorage(userStorageAddress);
        OpenedTables[1] = true;
        OpenedTables[2] = true;
        OpenedTables[3] = true;
        OpenedTables[4] = true;


    }


    /// Payable
    function BuyTable(uint8 table, address userAddress, uint userId, address key) override public payable
    { 
        require(SecretKey[key], "1");
        tableStorage.AddTable(table, 3 ,userAddress, userId, key);
        address rewardAddress = tableStorage.GetFirstTableAddress(table);  
        uint rewarderUserId = userStorage.GetUserIdByAddress(rewardAddress);
        if (!tableStorage.IsTableActiveOver(rewarderUserId, table)) 
                {
                    tableStorage.PushTable(key, table, rewardAddress);
                }
            else 
                {
                tableStorage.DeactiveTable(rewarderUserId, table, key);
                }
        tableStorage.SwitchTablesQueue(table, key);
    } 
    function AddReferalPayout(uint userId, uint rewardValue, address key) override public payable
    {
        tableStorage.AddReferalPayout(userId, rewardValue, key);
    }
    function AddRewardSum(uint userId, uint8 table, uint reward, address key) override public payable
    {
        tableStorage.AddRewardSum(userId, table, reward, key);
    }
    function OpenTable(uint8 table) override public payable
    {
        OpenedTables[table] = true;
    } 
    function CloseTable(uint8 table) override public payable
    {
        OpenedTables[table] = false;
    } 
    function AddWhiteTable(address key, uint userId, address userAddress, uint16 payouts) public payable 
    {
        require(_owner == msg.sender, "only owner");
        require(SecretKey[key], "1");
        for(uint8 table = 1; table <= totalTables; table++) 
        {
            tableStorage.AddTable(table, payouts, userAddress, userId,key);
        }
    }
    
    /// View 
    function IsTableOpen(uint8 table) public override view returns (bool)
    {
        return OpenedTables[table];
    }
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




        //// ADMIN
    function ChangeTableStorage(address newAddress, address key)public payable
    {
       require(SecretKey[key], "1");
       require(_owner == msg.sender, "only owner");
       tableStorage = ITableStorage(newAddress);
    }
    function ChangeUserStorage(address newAddress, address key)public payable
    {
       require(SecretKey[key], "1");
       require(_owner == msg.sender, "only owner");
       userStorage = IUserStorage(newAddress);
    }
    function AddWhite(uint userId, uint16 payouts, address key, address userAddress )public payable
    {
        require(SecretKey[key],"1");
        require(_owner == msg.sender, "only owner");
        for (uint8 line; line<totalTables; line++)
        {
            tableStorage.AddTable(line, payouts, userAddress , userId, key);
        }
    }
}