// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import '../Protect/ReentrancyGuard.sol';
import "../Interfaces/IUserStorage.sol";
import '../Interfaces/ITableStorage.sol';
import '../Interfaces/IPullStorage.sol';
import "../Repository/UserStorage.sol";
import "../Repository/TableStorage.sol";
import "../Repository/PullStorage.sol";
import "./Reinvest.sol";

contract UniqueMatrixGame is ReentrancyGuard
{
    address payable owner;
    address private _pullInvestAddress;

    modifier onlyOwner() 
    {
    require(owner == msg.sender);
        _;
    }

    IUserStorage userStorage;
    ITableStorage tableStorage;
    IPullStorage pullStorage;
    Reinvest reinvest;

    uint8 constant rewardPayouts = 3;
    uint8 constant rewardPercents = 60;
    uint8 constant buyPullPercent = 20;  

   

    constructor(
     address PullReinvestAddress
     ) 
    {
        owner = payable(msg.sender);
        userStorage = new UserStorage();
        tableStorage = new TableStorage();  
        pullStorage = new PullStorage(10 ether);
        _pullInvestAddress =  PullReinvestAddress; 
        reinvest = new Reinvest(
            address(pullStorage),
            address(userStorage),
            address(tableStorage),
            payable(address(this)));
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
    uint rewardableLinesCount = referralRewardPercents.length - 1;
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

    receive() external payable
    {
        require(isContract(msg.sender),"Buy tables only DaPP");
    }

    function registerWithReferrer(uint refId) public 
    {
        if (!userStorage.IsUserExistById(refId))
        {
            refId = 1;
        }
        _Register(msg.sender, refId);
    }

    function registerWhite(address userAddress,uint refId) public 
    {
        require(msg.sender == owner, "2");
        if (!userStorage.IsUserExistById(refId))
        {
            refId = 1;
        }
        _Register(userAddress, refId);
    }

    function BuyTable(uint8 table, uint refId) public payable nonReentrant 
    {
        require(!isContract(msg.sender), "Can not be a contract");
        require(table > 0 && table <= totalTables, "Invalid level");
        require(TablePrice[table] == msg.value, "Invalid BNB value");
        if (!userStorage.IsUserExist(msg.sender))
        { 
            registerWithReferrer(refId);
        }
        uint senderId = userStorage.GetUserIdByAddress(msg.sender); 
        for(uint8 level = 1; level < table; level++) 
        {
            require(tableStorage.IsTableActive(senderId,level), "All previous levels must be active");
        }       
        require(!tableStorage.IsTableActive(senderId, table), "Level already active"); 
        tableStorage.AddTotalValue(msg.value);
                              
        uint onePercent = msg.value / 100;              
        uint rewardForTable = onePercent * rewardPercents;   
        uint spend;                                           

        //  PAY FOR TABLE
        address rewardAddress = tableStorage.GetFirstTableAddress(table); 
        uint rewarderUserId = userStorage.GetUserIdByAddress(rewardAddress); 
        spend += rewardForTable;
        bool LVLSend = payable(rewardAddress).send(rewardForTable);    //// 0.024 =>   value = 0.016
        if(!LVLSend)
        {
            payable(owner).transfer(rewardForTable);
        }
        tableStorage.AddRewardSum(rewarderUserId, table, rewardForTable);

        // BUY TABLE
        _BuyTable(table, msg.sender);
                
        // REFERAL REWARDDS
        address userReferrer = userStorage.GetReferrer(msg.sender);
        for (uint8 line = 1; line <= rewardableLinesCount; line++) 
        {
            uint rewardValue = onePercent * referralRewardPercents[line];   // 
            spend += rewardValue;    
            bool refSend = payable(userReferrer).send(rewardValue);    //// 0.024 =>   value = 0.016
            if(!refSend)
            {
            payable(owner).transfer(rewardValue);
            }       
            uint refererId = userStorage.GetUserIdByAddress(userReferrer);
            tableStorage.AddReferalPayout(refererId, rewardValue);
            userReferrer = userStorage.GetReferrer(userReferrer);
        }

        /// BUY TICKET
        uint ticketCost = msg.value - spend;
        _BuyTicket(senderId, ticketCost);
        bool sentTicket = payable(_pullInvestAddress).send(ticketCost);           
        if (!sentTicket) 
        {
            payable(_pullInvestAddress).transfer(ticketCost);
        }  
    }
 
    function BuyTableReInvest(uint userId, uint value, uint8 table) public 
    {
        require(msg.sender == address(reinvest), "3");
        require(table > 0 && table <= totalTables, "Invalid level");
        require(TablePrice[table] == value, "Invalid BNB value");
        tableStorage.AddTotalValue(value);
        uint onePercent = value / 100;
        uint spend;
        address userAddress = userStorage.GetUserAddressById(userId);
        _BuyTable(table, userAddress);
        uint reward = onePercent * rewardPercents;
        spend += reward;
        address rewardAddress = tableStorage.GetFirstTableAddress(table);  
        uint rewarderUserId = userStorage.GetUserIdByAddress(rewardAddress);       
        bool sent = payable(rewardAddress).send(reward);           
        if (sent) 
        {
            tableStorage.AddRewardSum(rewarderUserId, table, reward);             
        } 
        else
        {
            owner.transfer(reward);
        }         
        address userReferrer = userStorage.GetReferrer(userAddress);
        for (uint8 line = 1; line <= rewardableLinesCount; line++) 
        {
            uint rewardValue = onePercent * referralRewardPercents[line];
            spend += rewardValue;
            payable(userReferrer).transfer(rewardValue);
            uint refererId = userStorage.GetUserIdByAddress(userReferrer);
            tableStorage.AddReferalPayout(refererId,  rewardValue);
            userReferrer = userStorage.GetReferrer(userReferrer);
        }
        uint ticketCost = value - spend;
        //pullController.BuyTicket(userId, ticketCost);
        bool sentTicket = payable(owner).send(ticketCost);           
        if (!sentTicket) 
        {
            payable(owner).transfer(ticketCost);
        }
    }
   


   /// PRIVATE
   function _Register(address userAddress, uint refId) internal 
   {
         if (!userStorage.IsUserExistById(refId))
        {
            refId = 1;
        }
        address refAddress = userStorage.GetUserAddressById(refId);
        userStorage.AddUser(userAddress, refAddress);
        uint8 line = 1;
        address ref = refAddress;
        while (line <= rewardableLinesCount && ref != address(0)) 
        {
           userStorage.AddReferal(ref);
           ref = userStorage.GetReferrer(ref);
           line++;
        }
   }
   function _BuyTable(uint8 table, address userAddress ) internal 
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
    function _BuyTicket(uint userId, uint value) internal 
    {
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
                pullStorage.SetTicket(value,  userId);
            } 
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
                pullStorage.SetTicket( lastValue,  userId);
            }    
            pullStorage.SetCurrentPullValue(lastValue);
            pullStorage.AddNewPull();
            if (residual > 0)
            {
                pullStorage.SetTicket( residual,  userId);
                pullStorage.SetCurrentPullValue(residual);
            }
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

    function ChangeReinvestAddress(address newAddress) external  
    {       
        require(owner == msg.sender, "only owner");                            
        _pullInvestAddress = newAddress;
    }
    function AddWhite(uint userId, uint16 payouts, address userAddress )public 
    {
        require(owner == msg.sender, "only owner");
        for (uint8 line = 1; line<=totalTables; line++)
        {
            tableStorage.AddTable(line, payouts, userAddress , userId);
        }
    }
    function AddWhiteNotFull(uint userId, uint16 payouts, address userAddress, uint tablesAdd)public 
    {
        require(owner == msg.sender, "only owner");
        require(tablesAdd < totalTables);
        for (uint8 line = 1; line<=tablesAdd; line++)
        {
            tableStorage.AddTable(line, payouts, userAddress , userId);
        }
    }
    function GetReinvestContractAddress() public view returns(address)
    {
        require(msg.sender == owner, "2");
        return address(reinvest);
    }
}

