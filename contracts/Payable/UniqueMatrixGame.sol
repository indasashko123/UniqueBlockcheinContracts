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


    uint8 constant rewardPayouts = 3;
    uint8 constant rewardPercents = 60;
    uint8 constant buyPullPercent = 20;  

   

    constructor(address PullReinvestAddress) 
    {
        owner = payable(msg.sender);
        userStorage = new UserStorage();
        tableStorage = new TableStorage();  
        pullStorage = new PullStorage(10 ether);
        _pullInvestAddress =  PullReinvestAddress; 
        AddWhite(1,25,owner);
        _started();
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

    function _started() private
    {
        _Register(address(0x9Ee86BF20397df40A4eFf81C24fE567870b9617b), 1);
        AddWhite(2, 3, address(0x9Ee86BF20397df40A4eFf81C24fE567870b9617b));
 
        _Register(address(0x7B1628580F850CAd2C3343c09d306c3F97a30d0a), 2);
        AddWhite(3, 3, address(0x7B1628580F850CAd2C3343c09d306c3F97a30d0a));

        _Register(address(0xA1e5f8e3475e4Be19934dB3eDE8bB735Cf533D50),3);
        AddWhiteNotFull(4,3,address(0xA1e5f8e3475e4Be19934dB3eDE8bB735Cf533D50), 8);

        _Register(address(0xE6179F7bAe844C73F7274111bf967Fd563C445A9),4);
        AddWhiteNotFull(5, 3, address(0xE6179F7bAe844C73F7274111bf967Fd563C445A9), 5);

        _Register(address(0x01eCc9bcf58c34bCB96392F516C0ebC9A4836727),5);
        AddWhiteNotFull(6, 3, address(0x01eCc9bcf58c34bCB96392F516C0ebC9A4836727), 5);

        _Register(address(0x74F65A4f841e17b6c6dCc363Cf4208Ec51d1837f), 2);
        AddWhiteNotFull(7, 3, address(0x74F65A4f841e17b6c6dCc363Cf4208Ec51d1837f), 8);
       
        _Register(address(0x865B4B1C7394F3930C87749Dc61d708DC8C7Ed3E), 7);
        AddWhiteNotFull(8, 3, address(0x865B4B1C7394F3930C87749Dc61d708DC8C7Ed3E), 6);

        _Register(address(0x5c4A78158f40D9817EcdFD0b49Ec280AC9C9b283), 8);
        AddWhiteNotFull(9, 3, address(0x5c4A78158f40D9817EcdFD0b49Ec280AC9C9b283), 6);

        _Register(address(0x0115ffc383226531D11646b5aAF7382D17473161), 9);
        AddWhiteNotFull(10, 3, address(0x0115ffc383226531D11646b5aAF7382D17473161), 7);

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
    function GetContractaAddress() public view returns(address[3] memory)
    {
        require(msg.sender == owner, "2");
        address[3] memory addresses;
        addresses[0] = (address(userStorage));
        addresses[1] = (address(tableStorage));
        addresses[2] = (address(pullStorage));
        return addresses;
    }
}

