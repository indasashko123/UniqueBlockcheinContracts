// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IUserStorage.sol';
import '../Interfaces/IPullStorage.sol';
import '../Interfaces/ITableStorage.sol';
import './UniqueMatrixGame.sol';
import '../Protect/ReentrancyGuard.sol';
import '../Interfaces/IDepositeStorage.sol';
import "../Repository/DepositeStorage.sol";

contract Reinvest is ReentrancyGuard
{
    address payable owner;


    IPullStorage pullController;
    IUserStorage userController;
    ITableStorage tableController;
    IDepositeStorage depositeController;
    UniqueMatrixGame game;
    constructor (
        address pullControllerAddress, 
        address userControllerAddress, 
        address tableControllerAddress,
        address payable gameAddress
        )
    {
        owner = payable(msg.sender);
        pullController = IPullStorage(pullControllerAddress);
        userController = IUserStorage(userControllerAddress);
        tableController = ITableStorage(tableControllerAddress);
        depositeController = new DepositeStorage();
        game = UniqueMatrixGame(gameAddress);

    }
    receive() external payable
    {    
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
 

    
    function RewardToPull(uint pullId) public payable 
    {
        require(pullController.IsPullExist(pullId), "Pull not found");
        uint LineLength = rewardableLinesCount; 
        uint TotalValue = msg.value;
        uint OnePercent =  pullController.GetPullCollectedSum(pullId)/100;       
        uint ticketsCount = pullController.GetTicketCountOnPull(pullId);
        for (uint tick = 1; tick<=ticketsCount; tick++)
        { 
            (uint UserId,uint sumFromTicket) = pullController.GetTicketInfo(pullId, tick);
            address UserAddress = userController.GetUserAddressById(UserId);
            uint RewardPercent =(100000000*sumFromTicket)/OnePercent; 
            uint UserReward = ((TotalValue/100)*RewardPercent)/100000000;

            /// User Reinvest Set
            uint UserReinvestValue = (UserReward/100)*40;
            depositeController.SetReinvestCell(UserId, UserReinvestValue);      
            UserReward -= UserReinvestValue;

            /// REFERALS REWARDS
            uint line = 1;
            uint RewardToRef = 0;
            address ReferalAddress = userController.GetReferrer(UserAddress);

            while (line <= LineLength && ReferalAddress != owner) 
            {
                uint ReferalReward = (UserReward/100)* referralRewardPercents[line];
                bool sentRef = payable(ReferalAddress).send(ReferalReward);  
                if (!sentRef)
                {
                    owner.transfer(ReferalReward);
                }
                uint RefererId = userController.GetUserIdByAddress(ReferalAddress);
                game.AddMemberReferalRewards(ReferalReward, RefererId);
                ReferalAddress = userController.GetReferrer(ReferalAddress);
                line++;
                RewardToRef +=  ReferalReward;
            }

            /// USER REWARD FROM PULL
            UserReward -= RewardToRef;
            bool sent = payable(UserAddress).send(UserReward);  
            if (!sent)
            {
                owner.transfer(UserReward);
            }
            game.AddMemberRewards(UserReward, UserId);         
        }
    }
    function ReinvestTable(uint8 table, address userAddress)external payable nonReentrant
    { 
        require(userController.IsUserExist(userAddress),"Not found user");
        uint value = TablePrice[table];
        uint userId = userController.GetUserIdByAddress(userAddress);
        require(depositeController.GetUserDeposite(userId) >=  value, "Not enoight token" );
        require(!tableController.IsTableActive(userId, table), "TableAlreadyActive");        
        bool sent = payable(address(game)).send(value);
        if(!sent)
        {
            payable(address(game)).transfer(value);
        }          
        depositeController.ReduceUserDeposite(value, userId);
        game.BuyTableReInvest(userId, value, table);
    } 
    





    ///// ADMIN
    function withDraw() external payable nonReentrant
    {
        require(owner == msg.sender, "only owner");
        owner.transfer(getContractBalance());
    }
    function getContractBalance() public view returns (uint) 
    {
        return address(this).balance;
    }

}