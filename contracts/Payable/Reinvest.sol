// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IUserController.sol';
import '../Interfaces/IPullController.sol';
import '../Interfaces/ITableController.sol';
import './MatrixGame.sol';
import '../Protect/ReentrancyGuard.sol';
import '../Interfaces/IDepositeController.sol';

contract Reinvest is ReentrancyGuard
{
    address payable owner;


    IPullController pullController;
    IUserController userController;
    ITableController tableController;
    IDepositeController depositeController;
    MatrixGame game;
    constructor (
        address pullControllerAddress, 
        address userControllerAddress, 
        address tableControllerAddress,
        address payable gameAddress,
        address depositeControllerAddres
        )
    {
        owner = payable(msg.sender);
        pullController = IPullController(pullControllerAddress);
        userController = IUserController(userControllerAddress);
        tableController = ITableController(tableControllerAddress);
        depositeController = IDepositeController(depositeControllerAddres);
        game = MatrixGame(gameAddress);
        depositeController.SetKey();
        game.SetKey();
    }
    receive() external payable
    {    
    }

    
    function RewardToPull(uint pullId) public payable 
    {
        require(pullController.IsPullExist(pullId), "Pull not found");
        uint[] memory rewardableLines = pullController.GetRewardableLines(); 
        uint TotalValue = msg.value;
        uint OnePercent =  pullController.GetPullCollectedSum(pullId)/100;     /// Цена. 1%     
        uint ticketsCount = pullController.GetTicketCountOnPull(pullId);
        for (uint tick = 1; tick<=ticketsCount; tick++)
        { 
            (address UserAddress, uint sumFromTicket, uint UserId) = pullController.GetTicketInfo(pullId, tick);
            uint RewardPercent = sumFromTicket/OnePercent; 
            uint UserReward = (TotalValue/100)*RewardPercent;
            
            /// User Reinvest Set
            uint UserReinvestValue = (UserReward/100)*40;
            depositeController.SetReinvestCell(UserId, UserReinvestValue);      
            UserReward -= UserReinvestValue;

            /// REFERALS REWARDS
            uint line = 1;
            uint RewardToRef = 0;
            address ReferalAddress = userController.GetReferrer(UserAddress);
            while (line <= rewardableLines.length-1 && ReferalAddress != owner) 
            {
                uint ReferalReward = UserReward/100*rewardableLines[line];
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
        uint value = tableController.GetTablePrice(table);
        uint userId = userController.GetUserIdByAddress(userAddress);
        require(depositeController.GetUserDeposite(userId) <  value, "Not enoight token" );
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
    function ChangeUserStorage(address newAddress) external payable 
    {   
        require(owner == msg.sender, "only owner");
        userController = IUserController(newAddress);
    }
    function ChangeTableStorage(address newAddress) external payable 
    {
        require(owner == msg.sender, "only owner");
        tableController = ITableController(newAddress);
    }
    function ChangePullStorage(address newAddress) external payable 
    {
        require(owner == msg.sender, "only owner");
        pullController = IPullController(newAddress);
    }
    function ChangeDepositeStorage(address newAddress) external payable 
    {
        require(owner == msg.sender, "only owner");
        depositeController = IDepositeController(newAddress);
        depositeController.SetKey();
    }
}