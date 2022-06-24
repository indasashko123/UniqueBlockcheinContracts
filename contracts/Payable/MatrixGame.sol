// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IUserController.sol';
import '../Interfaces/ITableController.sol';
import '../Interfaces/IPullController.sol';
import '../Protect/ReentrancyGuard.sol';


contract MatrixGame is ReentrancyGuard
{
    address payable owner;
    mapping (uint8 => address) private GetSeckretKey;
    mapping (address => bool) private SecretKey;
    address private _pullInvestAddress;

    modifier onlyOwner() 
    {
    require(owner == msg.sender);
        _;
    }

    IUserController userController;
    IPullController pullController;
    ITableController tableController;
    

    uint public turnover;      // Total pay from Tables in Game
    uint8 constant rewardPayouts = 3;
    uint8 constant rewardPercents = 60;
    uint8 constant buyPullPercent = 20;  

   

    constructor(address key ,
     address UserControllerAddress, 
     address PullControllerAddress,
     address TablesControllerAddress,
     address PullReinvestAddress
     ) 
    {
        SecretKey[key] = true;
        GetSeckretKey[1] = key; 
        userController = IUserController(UserControllerAddress);
        tableController = ITableController(TablesControllerAddress);  
        pullController = IPullController(PullControllerAddress);
        _pullInvestAddress =  PullReinvestAddress; 
    }




    receive() external payable
    {
        if(!isContract(msg.sender))
        {
            revert("Tables are not purchased directly");   
        }
    }
    function registerWithReferrer(uint refId) public payable 
    {
        require(!isContract(msg.sender), "Can not be a contract");
        if (!userController.IsUserExistById(refId))
        {
            refId = 1;
        }
        userController.Register(GetSeckretKey[1],msg.sender, refId);
    }
    
    function BuyTable(uint8 table, uint refId) public payable nonReentrant 
    {
        require(!isContract(msg.sender), "Can not be a contract");
        require(tableController.TableNumberIsValid(table), "Invalid level");
        require(tableController.GetTablePrice(table) == msg.value, "Invalid BNB value");
        if (!userController.IsUserExist(msg.sender))
        { 
            registerWithReferrer(refId);
        }
        uint senderId = userController.GetUserIdByAddress(msg.sender); 
        for(uint8 level = 1; level < table; level++) 
        {
            require(tableController.IsTableActive(senderId,level), "All previous levels must be active");
        }       
        require(!tableController.IsTableActive(senderId, table), "Level already active"); 
        address key = GetSeckretKey[1];

        // Общий оборот ++
        turnover += msg.value;
        uint onePercent = msg.value / 100;
        uint rewardForTable = onePercent * rewardPercents;
        uint spend;

        //  PAY FOR TABLE
        address rewardAddress = tableController.GetFirstTableAddress(table); 
        uint rewarderUserId = userController.GetUserIdByAddress(rewardAddress); 
        spend += rewardForTable;
        payable(rewardAddress).transfer(rewardForTable); 
        tableController.AddRewardSum(rewarderUserId, table, rewardForTable, key);

        // BUY TABLE
        tableController.BuyTable(table, msg.sender, key);
                
        
        // REFERAL REWARDDS
        address userReferrer = userController.GetReferrer(msg.sender);
        uint rewardableLinesCount = userController.GetReferalLines();
        for (uint8 line = 1; line <= rewardableLinesCount; line++) 
        {
            uint rewardValue = onePercent * userController.GetReferalPercent(line);
            spend += rewardValue;           
            payable(userReferrer).transfer(rewardValue);
            uint refererId = userController.GetUserIdByAddress(userReferrer);
            tableController.AddReferalPayout(refererId, rewardValue, key);
            if (userReferrer != owner)
            {
                userReferrer = userController.GetReferrer(userReferrer);
            }
        }

        /// BUY TICKET
        uint ticketCost = msg.value - spend;
        pullController.BuyTicket(msg.sender, ticketCost, key);
        bool sentTicket = payable(_pullInvestAddress).send(ticketCost);           
        if (!sentTicket) 
        {
            payable(_pullInvestAddress).transfer(ticketCost);
        }  
    }


    function BuyTableReInvest(uint userId, uint value, uint8 table, address key) public payable
    {
    require(SecretKey[key], "No accsess");
    require(tableController.TableNumberIsValid(table), "Invalid level");
    require(tableController.GetTablePrice(table) == value, "Invalid BNB value");
        turnover += value;
        uint onePercent = value / 100;
        uint spend;
        address userAddress = userController.GetUserAddressById(userId);
        tableController.BuyTable( table, userAddress, GetSeckretKey[1]);
        uint reward = onePercent * rewardPercents;
        spend += reward;
        address rewardAddress = tableController.GetFirstTableAddress(table);  
        uint rewarderUserId = userController.GetUserIdByAddress(rewardAddress);       
        bool sent = payable(rewardAddress).send(reward);           
        if (sent) 
        {
            tableController.AddRewardSum(rewarderUserId, table, reward, GetSeckretKey[1]);             
        } 
        else
        {
            owner.transfer(reward);
        }         
        uint rewardableLinesCount = userController.GetReferalLines();
        address userReferrer = userController.GetReferrer(userAddress);
        for (uint8 line = 1; line <= rewardableLinesCount; line++) 
        {
            uint rewardValue = onePercent * userController.GetReferalPercent(line);
            spend += rewardValue;
            payable(userReferrer).transfer(rewardValue);
            uint refererId = userController.GetUserIdByAddress(userReferrer);
            tableController.AddReferalPayout(refererId,  rewardValue, GetSeckretKey[1]);
            if (userReferrer != owner)
            {
                userReferrer = userController.GetReferrer(userReferrer);
            }
        }
        uint ticketCost = value - spend;
        pullController.BuyTicket(msg.sender, ticketCost, GetSeckretKey[1]);
        bool sentTicket = payable(_pullInvestAddress).send(ticketCost);           
        if (!sentTicket) 
        {
            payable(_pullInvestAddress).transfer(ticketCost);
        }
    }











    //// Admin
    function isContract(address addr) private view returns (bool)
    {
        uint32 size;
        assembly {
            size := extcodesize(addr)
        }
        return size != 0;
    }
    function withDraw() external payable nonReentrant
    {
        require(owner == msg.sender, "only owner");
        owner.transfer(getContractBalance());
    }
    function getContractBalance() public view returns (uint) 
    {
        return address(this).balance;
    }
    function ChangeUserStorage(address newAddress, address key) external payable 
    {   
        require(owner == msg.sender, "only owner");
        require(SecretKey[key], "NO");
        userController = IUserController(newAddress);
    }
    function ChangeTableStorage(address newAddress, address key) external payable 
    {
        require(owner == msg.sender, "only owner");
        require(SecretKey[key], "NO");
        tableController = ITableController(newAddress);
    }
    function ChangePullStorage(address newAddress, address key) external payable 
    {
        require(owner == msg.sender, "only owner");
        require(SecretKey[key], "NO");
        pullController = IPullController(newAddress);
    }
    function ChangeReinvestAddress(address newAddress, address key) external payable 
    {       
        require(owner == msg.sender, "only owner");                            
        require(SecretKey[key], "NO");
        _pullInvestAddress = newAddress;
    }
}

