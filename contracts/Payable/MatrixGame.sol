// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IUserController.sol';
import '../Interfaces/ITableController.sol';
import '../Interfaces/IPullController.sol';
import '../Protect/ReentrancyGuard.sol';
import "../Protect/SecretKey.sol";



contract MatrixGame is ReentrancyGuard, SecretKey
{
    address payable owner;
    address private _pullInvestAddress;

    modifier onlyOwner() 
    {
    require(owner == msg.sender);
        _;
    }

    IUserController userController;
    IPullController pullController;
    ITableController tableController;
    
    uint8 constant rewardPayouts = 3;
    uint8 constant rewardPercents = 60;
    uint8 constant buyPullPercent = 20;  

   

    constructor(
     address UserControllerAddress, 
     address PullControllerAddress,
     address TablesControllerAddress,
     address PullReinvestAddress
     ) 
    {
        owner = payable(msg.sender);
        userController = IUserController(UserControllerAddress);
        tableController = ITableController(TablesControllerAddress);  
        pullController = IPullController(PullControllerAddress);
        _pullInvestAddress =  PullReinvestAddress; 
        userController.SetKey();
        tableController.SetKey();
        pullController.SetKey();
    }




    receive() external payable
    {
        require(isContract(msg.sender),"Buy tables only DaPP");
    }
    function registerWithReferrer(uint refId) public 
    {
        if (!userController.IsUserExistById(refId))
        {
            refId = 1;
        }
        userController.Register(msg.sender, refId);
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
        tableController.AddTotalValue(msg.value);
                              
        uint onePercent = msg.value / 100;              
        uint rewardForTable = onePercent * rewardPercents;   
        uint spend;                                           

        //  PAY FOR TABLE
        address rewardAddress = tableController.GetFirstTableAddress(table); 
        uint rewarderUserId = userController.GetUserIdByAddress(rewardAddress); 
        spend += rewardForTable;
        bool LVLSend = payable(rewardAddress).send(rewardForTable);    //// 0.024 =>   value = 0.016
        if(!LVLSend)
        {
            payable(owner).transfer(rewardForTable);
        }
        tableController.AddRewardSum(rewarderUserId, table, rewardForTable);


        // BUY TABLE
        tableController.BuyTable(table, msg.sender);
                
        
        // REFERAL REWARDDS
        address userReferrer = userController.GetReferrer(msg.sender);
        uint rewardableLinesCount = userController.GetReferalLines();
        for (uint8 line = 1; line <= rewardableLinesCount; line++) 
        {
            uint rewardValue = onePercent * userController.GetReferalPercent(line);   // 
            spend += rewardValue;    
            bool refSend = payable(userReferrer).send(rewardValue);    //// 0.024 =>   value = 0.016
            if(!refSend)
            {
            payable(owner).transfer(rewardValue);
            }       
            uint refererId = userController.GetUserIdByAddress(userReferrer);
            tableController.AddReferalPayout(refererId, rewardValue);
            userReferrer = userController.GetReferrer(userReferrer);
        }

        /// BUY TICKET
        uint ticketCost = msg.value - spend;
        pullController.BuyTicket(msg.sender, ticketCost);
        bool sentTicket = payable(_pullInvestAddress).send(ticketCost);           
        if (!sentTicket) 
        {
            payable(_pullInvestAddress).transfer(ticketCost);
        }  
    }


    function BuyTableReInvest(uint userId, uint value, uint8 table) public payable Pass()
    {
    require(tableController.TableNumberIsValid(table), "Invalid level");
    require(tableController.GetTablePrice(table) == value, "Invalid BNB value");
        tableController.AddTotalValue(value);
        uint onePercent = value / 100;
        uint spend;
        address userAddress = userController.GetUserAddressById(userId);
        tableController.BuyTable( table, userAddress);
        uint reward = onePercent * rewardPercents;
        spend += reward;
        address rewardAddress = tableController.GetFirstTableAddress(table);  
        uint rewarderUserId = userController.GetUserIdByAddress(rewardAddress);       
        bool sent = payable(rewardAddress).send(reward);           
        if (sent) 
        {
            tableController.AddRewardSum(rewarderUserId, table, reward);             
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
            tableController.AddReferalPayout(refererId,  rewardValue);
            userReferrer = userController.GetReferrer(userReferrer);
        }
        uint ticketCost = value - spend;
        pullController.BuyTicket(msg.sender, ticketCost);
        bool sentTicket = payable(_pullInvestAddress).send(ticketCost);           
        if (!sentTicket) 
        {
            payable(_pullInvestAddress).transfer(ticketCost);
        }
    }
    function SetKey() public payable
    {
        this.Set(msg.sender);
    }

   function AddMemberReferalRewards(uint ReferalReward,uint RefererId) public payable Pass()
   {
       pullController.AddMemberReferalRewards(ReferalReward, RefererId);
   }
   function AddMemberRewards(uint UserReward, uint UserId) public payable Pass()
   {
        pullController.AddMemberRewards(UserReward, UserId);
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
    function ChangeUserStorage(address newAddress) external payable 
    {   
        require(owner == msg.sender, "only owner");
        userController = IUserController(newAddress);
        userController.SetKey();
    }
    function ChangeTableStorage(address newAddress) external payable 
    {
        require(owner == msg.sender, "only owner");
        tableController = ITableController(newAddress);
        tableController.SetKey();
    }
    function ChangePullStorage(address newAddress) external payable 
    {
        require(owner == msg.sender, "only owner");
        pullController = IPullController(newAddress);
        pullController.SetKey();
    }
    function ChangeReinvestAddress(address newAddress) external payable 
    {       
        require(owner == msg.sender, "only owner");                            
        _pullInvestAddress = newAddress;
    }
}

