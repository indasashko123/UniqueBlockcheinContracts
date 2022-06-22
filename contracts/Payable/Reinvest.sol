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
    mapping (uint8 => address) private GetSeckretKey;
    mapping (address => bool) private SecretKey;


    IPullController pullController;
    IUserController userController;
    ITableController tableController;
    IDepositeController depositeController;
    MatrixGame game;
    constructor (
        address key, 
        address pullControllerAddress, 
        address userControllerAddress, 
        address tableControllerAddress,
        address payable gameAddress,
        address depositeControllerAddres
        )
    {
        owner = payable(msg.sender);
        SecretKey[key] = true;
        GetSeckretKey[1] = key; 
        pullController = IPullController(pullControllerAddress);
        userController = IUserController(userControllerAddress);
        tableController = ITableController(tableControllerAddress);
        depositeController = IDepositeController(depositeControllerAddres);
        game = MatrixGame(gameAddress);
    }
    receive() external payable
    {    
    }

    
    function RewardToPull(uint pullId) external payable 
    {
        require(pullController.IsPullExist(pullId), "Pull not found");
        uint[] memory rewardableLines = pullController.GetRewardableLines(); 
        uint TotalValue = msg.value/100*60;              //// 60% от полученной суммы
        uint ToReinvestValue = msg.value - TotalValue;   //// 40% на реинвест              
        uint OnePercent =  pullController.GetPullCrondFindingSum(pullId)/100;     /// Доля от вложенного. 1%     
        uint ticketsCount = pullController.GetTicketCountOnPull(pullId);
        for (uint tick = 0; tick<ticketsCount; tick++)
        { 
            (address UserAddress, uint sumFromTicket, uint UserId) = pullController.GetTicketInfo(pullId, tick);
            uint RewardPercent = sumFromTicket/OnePercent;
            uint UserReward = TotalValue/100*RewardPercent;
   
            uint UserReinvestValue = ToReinvestValue/100*RewardPercent;
            depositeController.SetReinvestCell(UserId, UserReinvestValue, GetSeckretKey[1]);

            uint line = 1;
            uint referalPayCount;
            address ReferalAddress = userController.GetReferrer(UserAddress);

            /// REFERALS REWARDS

            while (line <= rewardableLines.length-1 && ReferalAddress != owner) 
            {
                uint ReferalReward = UserReward/100*rewardableLines[line];
                bool sentRef = payable(ReferalAddress).send(ReferalReward);  
                if (!sentRef)
                {
                    owner.transfer(ReferalReward);
                }
                uint RefererId = userController.GetUserIdByAddress(ReferalAddress);
                pullController.AddMemberReferalRewards(ReferalReward, RefererId, GetSeckretKey[1]);
                ReferalAddress = userController.GetReferrer(ReferalAddress);
                line ++;
                referalPayCount +=  ReferalReward;
            }
            /// USER REWARD FROM PULL
            UserReward = UserReward - referalPayCount;
            bool sent = payable(UserAddress).send(UserReward);  
            if (!sent)
            {
                owner.transfer(UserReward);
            }
            pullController.AddMemberRewards(UserReward, UserId, GetSeckretKey[1]);         
        }
    }
    function ReinvestTable(uint8 table, uint userId)external payable
    { 
        uint value = tableController.GetTablePrice(table);
        require(depositeController.GetUserDeposite(userId) <  value, "Not enoight token" );
        require(!tableController.IsTableActive(userId, table), "TableAlreadyActive");        
        bool sent = payable(address(game)).send(value);
        if(!sent)
        {
            payable(address(game)).transfer(value);
        }      
        depositeController.ReduceUserDeposite(value, userId, GetSeckretKey[1]);
        game.BuyTableReInvest(userId, value, table, GetSeckretKey[1]);
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
    function ChangeDepositeStorage(address newAddress, address key) external payable 
    {
        require(owner == msg.sender, "only owner");
        require(SecretKey[key], "NO");
        depositeController = IDepositeController(newAddress);
    }
}